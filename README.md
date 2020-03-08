# 说明
1.本项目完成`objc.io`《App架构--使用Swift进行iOS架构》中以MVC实现录音App的部分

2.项目由共有三个release版本。
    1.0版本：按照自己对MVC的理解实现
    2.0版本：参考书籍实现方式，重构代码，优化了Model层的代码
    3.0版本：抽象`FolderViewController`中`UITableviewDataSource`到`FolderViewControllerDataSource`，来减轻`ViewController`负担

3.实现效果
![avatar](/demo.gif)

# 需求介绍
1.App 由三个主要界面,Folder 文件目录界面,可以新建文件和编辑文件;Record界面 用来录音的;Player界面 用来播放录音.其中Floder 和 Record 界面是作为SplitViewController的子界面来使用的

2.App 需要对数据进行持久化,包括文件目录以及录音信息

# MVC中标准的通信方式
![avatar](/mvc.png)
 
 1.一个更新`Model`的`UI`事件到完成数据变更刷新UI的流程
① `View`发起`Viewaction`到`Controller`
②`Controller`调用`Model`层相关方法 
③`Model`层完成更改发送通知 
④`Controller`接收通知更新UI 这就是最标准的处理
需要注意的是对`Model`改变的行为和`View`层级的变化不应该发生的同一函数中，应该由第四步的观察者模式来实现。因为`Model`层变更可能会失败，或者数据可能以其他方式更改，`Controller`不应该预设变更的结果

# 对于Model层的思考
`Model`层不单单是完成接口字段的映射这么简单，它还应该承担数据处理的任务，而不是把这部分代码放到`ViewController`中
* 数据变形，让其能够直接在View上显示
* 创建业务需要的数据层
* 如有需要，实现数据存储的相关的功能

# ViewController 优化的方法
`ViewControler`职责：观察`Model`，展示`View`，为他们提供数据，以及接受`ViewAction`，在此职责外的任务都应该分离到其他层面
1.`ViewController` 管理一个主`View`即可，多余的界面性功能可以分离到`childViewController`来实现

2.对于一些`ViewController` 只关心结果不关心过程的操作，可以将其分离到`Model`层或者工具类中，如网络请求、获取用户当前位置、文件上传等操作

3.强化`Model`层数据处理的逻辑，要注意`Model`层的作用不单单承担定义接口字段的作用，还承担更多数据处理以及存储的作用

4.通过`extension`来共享代码
这有两个层面的含义。①直接给类添加扩展来添加方法或属性②通过`extension`给`protocol`提供默认实现，从而让遵循某一协议的类，都具备某种能力

5.提取对象。
许多大的`ViewController` 都有很多角色和职责，但是通常一个角色和一直职责可以被提取为一个单独的对象。例如`ViewController`中 `UITableViewDataSource` 类可以单独抽象出来作为一个类

# 参考借鉴
1.优化MT4项目。
场景：App主界面有一个自选列表界面，在多个界面有添加、删除自选的操作，那么每次进入自选列表都要重新请求数据
原因：没有一个`Model`层去维护自选数据，依赖网络去显示
解决：新建一个类，该类维护一个自选的数组；封装一个添加/删除自选的函数，完成之后更新数组数据，同时发出通知；自选界面接收通知，刷新界面
好处：解决每次请求自选数据，浪费流量的问题；同时封装的添加/删除自选函数，提高了代码的复用性

2.优化HD钱包的Model层
`EthManager`和`BtcManager`耦合了太多的业务逻辑，包括钱包对象的创建和数据存储。可对其做以下拆分
* Btc钱包和Eth钱包继承共同的`BaseModel`
* 拆分出一个`Model`层做钱包对象的创建
* 将存储从`Manager`中拆分出来，由一个`Store`类处理
* `EthManager`和`BtcManager`抽象成一个`Manager`类，管理`BaseModel`，实现`addWallet`、`deleteWallet`、`updateWallte`等方法