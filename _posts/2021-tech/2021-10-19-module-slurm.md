---
layout: mypost
title: Module & Slurm 计算集群管理工具
categories: [tech]
---

## Module 路径、环境变量管理工具

```sh
module avail  # list available modules
module load module_name  # load module
module unload module_name  # unload module
module purge  # unload all module
module list # list loaded modules
```

Module 配置文件可能保存在 `/usr/share/Modules/modulefile/` 中，在使用 `module avail` 命令时会显示该路径。这些配置文件语法非常易懂，可以查看、仿写。

## Slurm 作业配置

推荐使用脚本配置作业。典型的配置脚本：

```text
!/bin/bash

#SBATCH --job-name=helloworld

#SBATCH --nodes=1
###使用节点数量

#SBATCH --ntasks=1
###总的进程数(CPU核数)

##SBATCH --ntasks-per-node=1
###每个节点的进程数，1个节点此项无需指定

##SBATCH --gres=gpu:8
###每个节点使用的GPU数量，CPU作业此项此项无需指定

## ====================

##SBATCH --mem=96G
###申请预留内存大小，可选项

#SBATCH --partition=matrix3
###使用的分区，目前有6个集群分区，matrix0-5，默认matrix1

#SBATCH --workdir=/share3/xujiahao
###作业的工作目录，输出log在此路径
###此路径必须是NFS共享目录

#SBATCH --output=%j.out
###作业错误输出文件,%j代表作业ID

#SBATCH --error=%j.err
###作业正确输出文件

##SBATCH --begin=14:32
###作业开始执行时间，默认立即执行，可选项

##SBATCH --deadline=21:00
###作业强制终止时间，可选项

##SBATCH --mail-type=end
###邮件通知类型start/end/failed，end表示作业结束时邮件通知，可选项

#SBATCH --mail-user=xujiahao@momenta.ai
###邮件通知邮箱，可选项

module load basic
###加载环境变量，若不清楚，推荐使用module load basic

echo -e "
********************************************************************
Job Name:$SLURM_JOB_NAME,Job ID:$SLURM_JOBID,Allocate Nodes:$SLURM_JOB_NODELIST
********************************************************************\n\n"
###显示作业名称，作业ID，使用节点

##mpirun test_nccl weights.txt
###执行的程序，MPI作业，直接使用mpirun

srun ~/slurm/hello.sh
###执行的程序，普通作业，使用srun
```

除了在以上脚本中写明的设置外，一些重要信息：

- 作业脚本（如 `hello.sh`）运行时身份为当前用户身份
- 运行目录 `pwd` 默认为当前用户根目录，但任务 STDOUT / STDERR 会重定向到指定的文件中
- 可以使用 `~` 打头的路径指定脚本路径
- 使用 `squeue | grep username` 查询自己的作业
- 使用 `scancelall task_id / scancel task_id` 停止作业

