# GitTool
局域网式Git管理工具（本地仓库-》远程仓库-》服务器仓库），目前功能比较少，且无法应对rebase和cherrypick等会改变hash码的情况。

#该工具主要使用的是CoffeeScript，使用时需要安装nodejs、coffee、shelljs、http、fs、url等模块

#使用方法
#服务器（发布、打包仓库）
在安装配置环境后运行./Server可以直接启动服务器，目前不支持直接读取本地ip直接开启，hostip以及port需要自己手动配置，且保证服务器端的路径要和客户端的一致，需要自己手动关联远程remote的设置。

#远端仓库
无可执行代码

#客户端（本地仓库）
脚本文件一般放在./bin/底下，如有需要可以自行手动更换路径
./bin/workflow push @~num
./bin/workflow publish
./bin/workflow publish 191217 v1.0
./bin/workflow revert
./bin/workflow remove

例子 ->
1、run => ./bin/workflow publish
上面的指令主要用于第一次使用该工具时才会用到，因为第一次使用服务器时，没有对当前的仓库进行提交记录保存，因而无法使用revert，回滚会失败。没有含参的publish仅仅只有记录当前最新提交的hash码，因此第一次使用时一定要保证发布仓库的提交是最新的时候使用。

2、run => ./bin/workflow push @~2
bc323ddf1c6dab3489fbd0e13d48e69070670633  -> @~
97ceddc9d83f4489e66d0f33199282f0dda760c6  -> @~1
497b5dbbd6138070d5998f9e31ea26e3abe21b58  -> @~2
e8a28f971c193529916eb070ca139e0572dbbae1 
上面的指令主要会将本地仓库中当前分支底下的前三条提交的Hash码推送给服务器并通知服务器对我所推送提交的远端进行cherry-pick,可以反复提交，但是使用前要保证自己本地仓库的当前分支或者提交要push到远端仓库中，否则服务器无法取得本次提交的hash码

3、run => ./bin/workflow remove
上面的指令主要会将发布分支中所有跟本地仓库中当前分支有关的提交删除，并重新提取构建build分支，使用时需要把当前分支切换到要移除的分支下运行该命令即可

4、run => ./bin/workflow revert
上面的指令主要会将发布仓库的build分支进行移除（主要用于有人提交时出现重复提交的问题）

5、run => ./bin/workflow publish 191217 v1.0
上面的指令主要会将发布仓库的build分支直接合并到发布主干上，合并成功后删除build分支，合并以后的提交将会单独创建一个版本分支和版本标识
