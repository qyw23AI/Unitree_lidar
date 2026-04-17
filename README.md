# Unitree Lidar

本仓库已将以下项目以 Git 子模块方式接入，便于统一拉取和维护：

- unilidar_sdk
- serial_driver_ros2
- FAST_LIVO2_ROS2_relocation_ultra

## 子模块使用方法

### 1. 首次克隆仓库

推荐直接递归克隆子模块：

```bash
git clone --recurse-submodules https://github.com/qyw23AI/Unitree_lidar.git
```

如果你已经克隆了主仓库，也可以进入仓库后初始化子模块：

```bash
git submodule update --init --recursive
```

### 2. 拉取主仓库和子模块更新

推荐使用递归拉取：

```bash
git pull --recurse-submodules
git submodule update --init --recursive
```

### 3. 更新单个子模块

进入对应目录后执行：

```bash
git pull
```

或者在主仓库中更新指定子模块：

```bash
git submodule update --remote --merge unilidar_sdk
git submodule update --remote --merge serial_driver_ros2
git submodule update --remote --merge FAST_LIVO2_ROS2_relocation_ultra
```

### 4. 查看子模块状态

```bash
git submodule status
```

### 5. 常见维护命令

- 克隆后初始化所有子模块：`git submodule update --init --recursive`
- 同步子模块配置：`git submodule sync --recursive`
- 更新所有子模块到远端最新提交：`git submodule update --remote --recursive`

## 说明

子模块本身是独立仓库，主仓库只记录它们的固定提交指针。
如果子模块内部有本地修改，`git status` 会在主仓库中显示对应子模块为已修改状态。