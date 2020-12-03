---
layout: mypost
title: C++ 与 Java 中的多态与多重继承实现
categories: [blog, oop, lang]
---

> 首次发表于 https://segmentfault.com/a/1190000022095060

## 多态问题

笔者校招面试时被问到了著名问题「C++ 与 Java 如何实现多态」，然后不幸翻车。过于著名反而没有去准备，只知道跟虚函数表有关。面试之后比较了 C++ 和 Java 多态的实现的异同，一并记录在这里。

## C++ 多态的虚指针实现

首先讨论 C++. 多态也即子类对父类成员函数进行了重写 (Override) 后，将一个子类指针赋值给父类，再对这个父类指针调用成员函数，会调用子类重写版本的成员函数。简单的例子：

```cpp
class Parent1 {
   public:
    virtual void sayHello() { printf("Hello from parent1!\n"); }
};

class Child : public Parent1 {
   public:
    virtual void sayHello() { printf("Hello from child!\n"); }
};

int main() {
    Parent1 *p = new Child();
    p->sayHello();   // get "Hello from child!"
}
```

首先需要明白，对于底层实现而言，成员函数就是第一个参数为对象指针的函数，编译器自动将对象指针添加到函数参数中并命名为 this 指针，除此之外与普通函数并无本质不同。对于非多态的成员函数调用，与非成员函数调用过程基本是一致的，根据参数列表（参数列表中包含对象指针类型）和函数名在编译时确定实际调用的函数。

为了实现多态，不能只根据对象指针类型推断函数签名，也即例子中，`p->sayHello()` 这一行代码在执行时不能只根据 `p` 的类型确认调用的函数应该是 `Parent::sayHello` 还是 `Child:sayHello`。在多态机制下，每个类父类和子类都需要在其数据结构中多携带一个指针，这个指针指向该类的虚函数表。

类的虚函数表也即所有可能发生重写的函数指针表，对象创建时根据其实际类型决定其虚函数指针指向的虚函数列表。如在上文的例子中，Parent1 和 Child 类的虚函数列表都只有一个函数，分别是 `Parent1::sayHello` 和 `Child::sayHello`. 编译器在编译时将会把函数调用翻译为「引用虚函数表中的第 N 个函数」这样的指令，比如本例中翻译为「引用虚函数表中第一个函数」。在运行时读取虚函数表中真正的函数指针。运行时 CPU 代价基本是一次指针解引用和一次下表访问。

Parent1 和 Child 对象都没有自定义的数据结构。运行以下代码能够确认 Parent1 和 Child 对象的真实数据结构大小都是 8 字节，也即只有虚函数列表指针。把 Parent1 和 Child1 对象作为 64 位整数输出，可以看到 p1, p2 的值相同，p3 与前两者不同。这个值也即相应类的虚函数表地址。

```
Parent1* p1 = new Parent1();
Parent1* p2 = new Parent1();
Parent1* p3 = new Child();
printf("sizeof Parent1: %d, sizeof Child: %d\n",
    sizeof(Parent1), sizeof(Child));
printf("val on p1: %lld\n", *(int64_t*)p1);
printf("val on p2: %lld\n", *(int64_t*)p2);
printf("val on p3: %lld\n", *(int64_t*)p3);
```

## C++ 多态与多重继承

有一个非常有意思的问题：C++ 发生多重继承时，如何支持多态。刚刚提到，多态的原理是编译器将成员函数调用编译为「引用虚函数表中第 N 个函数」，虚函数表在对象数据结构中的位置和要调用虚函数列表中的第几个函数在编译时都是需要确定的。多重继承对象如果只有一个虚函数列表，那不同父类的虚函数列表中的位置就要发生冲突。如果有多个虚函数列表，编译时就难以确定虚函数列表指针在数据结构中的位置。C++ 采取了非常精妙的做法：将所有父类的数据结构（包括虚指针列表）在该对象的数据结构上依次排列，该对象的指针正常指向数据结构起始位置。**当指针发生类型转换时，C++ 编译器会对指针的值尽可能的进行调整，使其指向该指针类型应该对应的位置。指针的值在这个过程中发生了变化。**

比如，Child 类继承了 Parent1, Parent2 两个类，则在 Child 指针转换为 Parent1 指针时，不对指针的值进行调整，因为 Parent1 是 Child 的第一个父类。但将 Child 转换为 Parent2 时，需要将指针指增加 Parent1 数据结构长度的值，使指针指向对应 Parent2 数据结构开始位置。在本例子中，Parent1 数据结构只有虚函数列表指针，在 64 位机器上长度为 8. 因此，在 Child 指针转换为 Parent2 指针时，其值增加了 8.

```
class Parent1 {
   public:
    virtual void sayHello() { printf("Hello from parent1!\n"); }
};

class Parent2 {
   public:
    virtual void sayHi() { printf("Hi from Parent2!\n"); }
};

class Child : public Parent1, public Parent2 {
   public:
    virtual void sayHello() { printf("Hello from child!\n"); }
    virtual void sayHi() { printf("Hi from child!\n"); }
};

int main() {
    Child *p = new Child();
    printf("size of Child: %d", sizeof(Child));
    printf("pointer val as Child*: %lld\n", int64_t(p));
    printf("pointer val as Parent1*: %lld\n", int64_t((Parent1*)p));
    printf("pointer val as Parent2*: %lld\n", int64_t((Parent2*)p));
}
```

运行这段代码，会发现 Child 数据结构大小增长到 16，也即两个指针。并且指针的值在后两次类型转换时是不同的，在 64 位机器上相差 8 个字节，也即 Parent1 的数据结构大小。另外如果将 `p` 转换成 Void 指针再转换为 Parent 指针，此时编译器就不能正确推断这个偏移量，此时就会发生未定义行为。

> 这个特性其实说明了一个非常有意思的事实：C++ 编译器在编译时能够推断指针的偏移量，那么编译器也应该可以推断该指针指向对象的真实类型。那么，既然可以编译时推断对象真实类型，那要虚函数表又有何用？直接推断正确的函数调用不就可以了吗？问题在于，如果真的在编译时推断多态函数调用，就意味着要为不同类型的对象生成不一样的二进制代码。同一行代码，根据指针值的不同，产生的函数调用不同。这样一来也意味第三方库需要提供源代码，来进行相关的推断，类似于模板库。这都是不可接受的，因此虚函数列表仍然有必要。借助虚函数列表，使用指针的代码能够生成一致的机器码。
> 
> 从另一个角度理解，编译器在编译一个完整的 App 时确实能够推断所有变量的真实类型，但这需要联系过多上下文。编译一段代码却需要这段代码输入参数的除类型之外的上下文信息，并根据上下文信息生成不同的二进制文件，这是不可接受的。

## Java 多态比较

由于 Java 的多态机制比 C++ 简单，理论上可以使用 C++ 的机制实现 Java 多态。但 C++ 跟 Java 有一点决定性的不同：C++ 要求父类成员方法必须有 Virtual 关键字修饰时才能被重写。这就意味着编译器在编译父类时就能确认那些函数可能被重写，于是可以对不可能重写的函数直接在编译时决定调用的具体函数，而对可能重写的函数使用虚指针表处理。而 Java 的方法默认都是可以重写的，因此可以认为 Java 方法调用都需要经过查询虚函数列表的过程，会比 C++ 不重写函数多一点开销。

Java 不支持多重继承，但 Java 支持接口 Interface, 接口跟多重继承有相似之处，不能简单的使用一个虚函数表查找。类需要为其实现的每个 Interface 生成一个虚函数列表，跟 C++ 的情况类似。[OpenJDK 文档指出](https://wiki.openjdk.java.net/display/HotSpot/InterfaceCalls)，在类定义中找到 Interface 的虚函数列表的办法是很粗暴的：在类实现的所有 Interface 列表中遍历查找。文档中指出，真正的多重继承是罕见的，通常可以归结为单继承。对此遍历过程可能有各种优化，笔者没有深入了解。

思考 Java 和 C++ 的一点不同：C++ 没有运行时类型，由编译器在编译时尽力保证指针指向的位置有对象正确的数据结构。将子类指针赋值给父类指针变量时，编译器尽力对其进行调整，但如果发生了 Void 指针赋值等，则编译器无法保证指针指向的位置有正确的对象数据结构。这一步只要语法上没有错误，就不会立即报错，编译器也无法确认是否会发生问题，一定要等到该指针实际进行解引用等发生异常才会报错。Java 有运行时类型，在将对象赋值给不同的类型的变量时，会在运行时进行类型检查，如果没有正确的类型继承关系，会在赋值时报错。

另外，对比 Java 的 Interface 和 C++ 的多重继承，会发现 Interface 的运行时时间开销要比 C++ 多重继承大得多。但是 C++ 多重继承需要为每个父类附加一个指针，并且编译器在编译时需要完成更多的工作。Java 相对于 C++ 是更加「强类型」的语言。