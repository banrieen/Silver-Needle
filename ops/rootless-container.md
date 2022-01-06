# podman rootless

* Rootless 基础：
    + cgroups-v2
    + runtime: [crun]()
    + 网络： [slirp4netns](https://github.com/rootless-containers/slirp4netns#install)
    + 文件系统： [fuse-overlayfs](https://github.com/containers/fuse-overlayfs)
## 性能增强点
* CRUN：

| 	             |crun 	|    runc |	 %   |
|----------------|------|---------|------|
|100 /bin/true 	 |0:01.69| 	0:3.34|-49.4%|

* slirp4netns：

|Implementation | MTU=1500 |MTU=4000    |MTU=16384 	 |MTU=65520   |
|---------------|----------|------------|------------|------------|
|vde_plug 	    | 763 Mbps |Unsupported |Unsupported |Unsupported |
|VPNKit 	    | 514 Mbps | 526 Mbps 	|540 Mbps 	 |Unsupported |
|slirp4netns 	| 1.07 Gbps| 2.78 Gbps 	|4.55 Gbps 	 |9.21 Gbps   |

## 风险点
* crun， server版估计最早在2022-06支持，目前滚动版支持
* Podman uses the slirp4netns program to set up User mode networking for unprivileged network namespace. Slirp4netns allows Podman to expose ports within the container to the host. Note that the kernel still will not allow a non-privileged process to bind to ports less than 1024. Podman-1.1 or later is required for binding to ports.
* Rootless Podman can use user namespace for container separation, but you only have access to the UIDs defined in the /etc/subuid file.