# BatchMinter
一个合约Mint工具
原本只针对于批量撸XEN，但是参考
[简单实现一个通用型薅羊毛合约](https://mirror.xyz/0x3dbb624861C0f62BdE573a33640ca016E4c65Ff7/VoBIa7fC_lNLw6TPutj16KztvnQffDdBOv_A1Z2AxUw)
并借鉴其代码进行开发

# 文档简要说明

- contracts
    - BatcherV0.sol   最基础的批量mint合约 利用create 批量创建合约
    - BatcherV1.sol   利用汇编create2创建合约 但存在问题
    - BatcherV2.sol   利用汇编create2创建合约 修复问题
    - BatcherV3.sol   通用批量Mint合约 而非只针对于XEN 汇编create2创建合约，调用方法和参数以call data方式通过js脚本传入

BatcherV2.sol 只在 BatcherV1.sol的基础上
> 	address private original;
> 修改为  
> address private immutable original;

- test
    - batcherV0.js   测试BatcherV0.sol
    - batcherV1.js   测试BatcherV1.sol
    - batcherV1Attack.js   测试BatcherV1.sol存在的权限Bug
    - batcherV2.js   测试BatcherV2.sol
    - batcherV3.js   测试BatcherV3.sol


# gas费消耗对比

### BatcherV0.sol
create创建合约
![](https://github.com/Cat2Boy/BatchMinter/blob/master/img/V0.png?raw=true)
### BatcherV1.sol
汇编create2创建合约
![](https://github.com/Cat2Boy/BatchMinter/blob/master/img/V1.png?raw=true)

### BatcherV3.sol
汇编create2创建合约，调用方法和参数以call data方式通过js脚本传入
![](https://github.com/Cat2Boy/BatchMinter/blob/master/img/V3.png?raw=true)