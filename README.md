# 🍏 Isaac ROS Template

**REPOSITORY UNDER CONSTRUCTION**

Do you want to build your own NVIDIA Isaac ROS docker for your robot? this template fit for you!

**You only need to fork this repository!**

# What do you need?

You need:
 * [NVIDIA Jetson](https://developer.nvidia.com/buy-jetson)
   *  NVIDIA Jetson AGX Xavier
   *  NVIDIA Jetson Xavier NX
   *  NVIDIA Jetson Nano (4Gb or 2Gb)
 * [NVIDIA Jetpack 4.6.1](https://developer.nvidia.com/jetpack-sdk-461)

If you are looking to build a docker container for **x86 machines**, please look the [NVIDIA Isaac common](https://github.com/NVIDIA-ISAAC-ROS/isaac_ros_common) repository 

# Where to edit?

There are three parts on this template to edit:
1. [Dockerfile](#dockerfile)
2. [01_isaac_ros.rosinstall](#01_isaac_rosrosinstall)
3. [02_your_ros2_pkgs.rosinstall](#02_your_ros2_pkgsrosinstall)

Let's move step by step and learn where you need to change

## [Dockerfile](/Dockerfile)

There are mainly 3 stage where you can work:
 * **Stage 2** _(around line 128)_: "Install dedicate packages for Isaac ROS"
 * **Stage 4** _(around line 161)_: "Install your ROS2 dependecies"
 * **Stage 7** _(around line 206)_: "Write your runtime command at startup"

### (Stage 2) Install dedicate packages for Isaac ROS

If you are working with a specific Isaac ROS package, maybe you need to add specific dependecies

### (Stage 4) Install your ROS2 dependecies

Like the [stage 2](#stage-2-install-dedicate-packages-for-isaac-ros) write in this stage all dependecies you need to be able to build your ROS2 packages.

**Remember to follow the Docker writlines guidelines to install al you need.**

### (Stage 7) Write your runtime command at startup

In this stage you need to uncomment the last line and write your specific launcher you want to run.

```Dockerfile
# CMD ["ros2", "launch", "your_pkg", "your_launcher.launch.py"]
```

## [01_isaac_ros.rosinstall](/01_isaac_ros.rosinstall)

This *rosinstall* file collect all Isaac ROS repository you need to use for your robot.

Do you know how to make a rosinstall file? The full rosinstall documentation is available [here!](https://docs.ros.org/en/independent/api/rosinstall/html/rosinstall_file_format.html)

Briefly you need only to add after Isaac ROS common, 3 lines like below:

```yml
- git:
    local-name: <REPOSITORY NAME>
    uri: <REPOSITORY URL>
```

## [02_your_ros2_pkgs.rosinstall](/02_your_ros2_pkgs.rosinstall)

Like [above](#01isaacrosrosinstall) you can add here all your workspaces you want to add in your Dockerfile

# Build Isaac ROS Docker image

```
bash build_image.bash [PROJECT_NAME]
```

**PROJECT_NAME** = Name project build

**Options:**
 * **-v** - Verbose
 * **-ci** - Build docker without cache
 * **--push** - Push docker image. Before to push, you need to be logged in
 * **--tag [TAG_NAME]** - Tag release (Default tag: *latest*)
 * **--pull-base-image** - Force to re-pull the base image

This script also *check* in the beginning if:
 1. You are running on ARM64 architecture
 2. Your NVIDIA Jetson have the [right requirements](#what-do-you-need)
 3. Your NVIDIA Jetson use the right NVIDIA runtime container and is able to build a certain of Isaac ROS packages

## Example output

Such as example if you want to build an image `isaac_ros_template` you will need to write:

`bash build_image.bash isaac_ros_template` where the docker image will be: `isaac_ros_template:latest`

# Reference

* [NVIDIA Isaac](https://developer.nvidia.com/isaac)
* [NVIDIA Isaac ROS GEMs](https://developer.nvidia.com/isaac-ros-gems)
* [NVIDIA Isaac ROS GEMs repositories](https://github.com/NVIDIA-ISAAC-ROS)
* [NVIDIA Jetson](https://www.nvidia.com/en-gb/autonomous-machines/embedded-systems/)
* [NVIDIA Jetson containers](https://github.com/dusty-nv/jetson-containers)
* [NVIDIA Jetpack](https://developer.nvidia.com/embedded/jetpack)

Developer blog posts and webinars:
 * [Integrating Isaac ROS Visual Odometry GEM on Jetson](https://info.nvidia.com/isaac-ros-and-nvidia-jetson-wbn.html)
 * [Isaac ROS tutorial](https://github.com/rbonghi/isaac_ros_tutorial) Many examples to build your own docker for Isaac ROS
 * [Designing Robots with NVIDIA Isaac GEMs for ROS](https://developer.nvidia.com/blog/designing-robots-with-isaac-gems-for-ros/)


Robot example with Isaac ROS:
 * [nanosaur.ai](https://nanosaur.ai)
 * [nanosaur architecture](https://nanosaur.ai/architecture/)
 * [nanosaur_perception](https://github.com/rnanosaur/nanosaur_perception) GPU accelerated repository

