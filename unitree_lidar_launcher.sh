#!/bin/bash

# 脚本功能：一键启动 MID360 雷达 + FAST-LIVO2（使用重定位）
# 使用说明：1. 赋予执行权限  2. 直接运行脚本

# 定义工作空间根目录和命令（请确认路径与你的实际路径一致！）
WORKSPACE="/home/r1/Unitree_lidar/FAST_LIVO2_relocation_revise"
CMD1="source install/setup.bash && ros2 launch livox_ros_driver2 msg_MID360_launch.py"
CMD2="source install/setup.bash && ros2 launch fast_livo mapping_avia.launch.py use_rviz:=true" #必须启动两个fast-livo2,因为后面重定位成功后，会关闭重定位的那个fast-livo2
CMD3="source install/setup.bash && ros2 launch example_teaser_gicp.launch.py"
SERIAL_WORKSPACE="/home/r1/Unitree_lidar"
CMD4="source /home/r1/Unitree_lidar/install/setup.bash && source /home/r1/Unitree_lidar/FAST_LIVO2_relocation_revise/install/setup.bash && ros2 launch serial_driver serial_driver.launch.py"

# 启动延迟（秒）：默认均为0以最快速度启动，可通过环境变量覆盖
# 例如：LIDAR_DELAY_12=1 LIDAR_DELAY_23=1 ./unitree_lidar_launcher.sh
DELAY_12="${LIDAR_DELAY_12:-0}"
DELAY_23="${LIDAR_DELAY_23:-0}"
DELAY_34="${LIDAR_DELAY_34:-0}"

# 检查gnome-terminal是否安装（Ubuntu默认已装）
if ! command -v gnome-terminal &> /dev/null; then
    echo "错误：未找到gnome-terminal，请安装后重试！"
    echo "安装命令：sudo apt install gnome-terminal"
    exit 1
fi

# 检查工作空间路径是否存在
check_path() {
    if [ ! -d "$1" ]; then
        echo "警告：路径不存在 -> $1"
        echo "请确认路径是否正确，脚本将继续执行..."
        sleep 3
    fi
}
check_path "$WORKSPACE"
check_path "$SERIAL_WORKSPACE"

# 启动第一个终端：运行 MID360 雷达驱动
echo "启动终端1：MID360 雷达驱动..."
gnome-terminal --title="MID360_driver" --working-directory="$WORKSPACE" -- bash -c "$CMD1; exec bash"

# 可选延迟：默认0秒（最快启动）
sleep "$DELAY_12"

# 启动第二个终端：运行 FAST-LIVO2（不使用重定位）
echo "启动终端2：FAST-LIVO2（不使用重定位）..."
gnome-terminal --title="FAST_LIVO2_mapping" --working-directory="$WORKSPACE" -- bash -c "$CMD2; exec bash"

# 可选延迟：默认0秒（最快启动）
sleep "$DELAY_23"

# 启动第三个终端：运行 FAST-LIVO2 + 重定位
echo "启动终端3：FAST-LIVO2（重定位）..."
gnome-terminal --title="FAST_LIVO2_relocalization" --working-directory="$WORKSPACE" -- bash -c "$CMD3; exec bash"

# 可选延迟
sleep "$DELAY_34"

# 启动第四个终端：运行串口数据发送
echo "启动终端4：serial_driver_ros2..."
gnome-terminal --title="serial_driver_ros2" --working-directory="$SERIAL_WORKSPACE" -- bash -c "$CMD4; exec bash"

# 提示信息
echo "所有终端已启动！"
echo "MID360 是网口雷达，通常不需要串口权限设置。"

