

## 是什么
一句话总结：
K8s 是云原生技术生态的核心，被称为容器编排领域的事实标准

Kubernetes（简称 K8s）主要属于云计算和云原生（Cloud Native）技术领域。
具体来说，它在以下几个核心技术细分领域占据主导地位：
容器编排 (Container Orchestration)： K8s 是用于自动部署、扩展和管理容器化应用程序的开源系统。
云计算基础设施 (Cloud Infrastructure)： 它常被称为“云时代的操作系统”，在现代数据中心和云服务中用于构建、扩展和管理应用集群。
DevOps 与持续交付 (CI/CD)： K8s 支持敏捷开发、自动化部署、弹性伸缩和灰度发布，是现代 DevOps 流程中的关键工具。


## 项目应用


部署CSV
```
步骤,资源类型,资源名称,命名空间,部署类型,YAML路径,镜像包名称,备注
1,Namespace,business-service,K8S_NAMESPACE,更新,k8s-resources/alert-rollback-ttl-namespace.yaml,,命名空间
2,ConfigMap,shandong-alert-rollback-ttl-workspace-conf,K8S_NAMESPACE,更新,k8s-resources/workspace-frontend-cfg-configmap.yaml,,工作台字典
3,ConfigMap,shandong-alert-rollback-ttl-screen-conf,K8S_NAMESPACE,更新,k8s-resources/screen-frontend-cfg-configmap.yaml,,大屏字典
4,Deployment,shandong-alert-rollback-ttl,K8S_NAMESPACE,更新,k8s-resources/alert-rollback-ttl-backend-deployment.yaml,alert-rollback-ttl_v202512301945.tar.gz,后端负载
5,Service,shandong-alert-rollback-ttl,K8S_NAMESPACE,更新,k8s-resources/alert-rollback-ttl-backend-service.yaml,,后端服务
6,Deployment,shandong-alert-rollback-ttl-workspace-web,K8S_NAMESPACE,更新,k8s-resources/workspace-frontend-deployment.yaml,workspace_v202512301900.tar.gz,工作台负载
7,Service,shandong-alert-rollback-ttl-workspace,K8S_NAMESPACE,更新,k8s-resources/workspace-frontend-service.yaml,,工作台服务
8,Deployment,shandong-alert-rollback-ttl-screen-web,K8S_NAMESPACE,更新,k8s-resources/screen-frontend-deployment.yaml,screen_v202512301945.tar.gz,大屏负载
9,Service,shandong-alert-rollback-ttl-screen,K8S_NAMESPACE,更新,k8s-resources/screen-frontend-service.yaml,,大屏服务
```

这个表格描述了一套应用在 Kubernetes (K8s) 环境中的部署交付步骤与资源清单。我来逐项解释每个字段和步骤的含义，帮助你理解整个部署流程。

🧩 通用列说明
步骤：部署的执行顺序，数字越小越先执行。

资源类型：K8s 中的对象种类，如 Namespace、ConfigMap、Deployment、Service。

资源名称：部署到集群后该资源的实际名字，用于标识和关联。

命名空间：资源归属的逻辑分区。此处的 K8S_NAMESPACE 是一个变量占位符，实际部署时会替换为真实的命名空间名称（很可能就是第一步创建的 business-service）。

部署类型：均为“更新”，表明采用声明式更新（如 kubectl apply），不存在则创建，已存在则更新配置。

YAML 路径：资源定义文件的相对路径。

镜像包名称：若资源为 Deployment（带容器），则对应所使用的 Docker 镜像包；若为空则说明该资源不涉及容器镜像（如 Service 仅暴露网络）。

备注：中文描述，便于理解用途。


📋 逐步解析

步骤 1: Namespace – business-service
含义：创建一个名为 business-service 的命名空间。
作用：后续所有资源（步骤2~9）都会被部署到这个命名空间下，实现环境隔离和资源分组。
YAML 路径：k8s-resources/alert-rollback-ttl-namespace.yaml 很可能只定义了一个 Namespace 对象。

步骤 2: ConfigMap – shandong-alert-rollback-ttl-workspace-conf
含义：创建/更新一个名为 ...-workspace-conf 的 ConfigMap。
作用：为工作台前端（步骤6的 Deployment）提供非敏感的配置数据（如环境变量、配置文件），实现配置与代码解耦。
YAML 路径：k8s-resources/workspace-frontend-cfg-configmap.yaml 定义了 ConfigMap 的数据内容。

步骤 3: ConfigMap – shandong-alert-rollback-ttl-screen-conf
含义：创建/更新一个名为 ...-screen-conf 的 ConfigMap。
作用：为大屏前端（步骤8的 Deployment）提供配置，与大屏 Deployment 配套使用。

步骤 4: Deployment – shandong-alert-rollback-ttl
资源类型: Deployment(负载)
名称：shandong-alert-rollback-ttl（后端服务）
镜像包：alert-rollback-ttl_v202512301945.tar.gz
作用：部署后端服务的Pod/容器。该镜像包包含业务逻辑，Deployment负责管理副本数、更新策略、健康检查等，保证后端持续运行。
关联：步骤5会为它创建Service，使其对内可访问。

步骤 5: Service – shandong-alert-rollback-ttl
作用：为步骤4的后端Deployment 创建一个稳定的网络入口(ClusterIp或NodePort等)，实现服务发现与负载均衡。其他前端Pod可通过该Service名称访问后端API。

步骤 6: Deployment – shandong-alert-rollback-ttl-workspace-web
资源类型：Deployment（负载）
名称后缀：workspace-web（工作台前端）
镜像包：workspace_v202512301900.tar.gz
作用：部署工作台前端界面的容器。通常为 Nginx + 编译后的静态文件，对外提供用户操作界面。
配置引用：步骤2的 ConfigMap 会被挂载或注入到这个 Deployment 中，以区分环境。

步骤 7: Service – shandong-alert-rollback-ttl-workspace
作用：为工作台前端Deployment创建Service，使其可在集群内部或外部(通过Ingress/NodePort)访问

步骤 8: Deployment – shandong-alert-rollback-ttl-screen-web
资源类型：Deployment（负载）
名称后缀：screen-web（大屏前端）
镜像包：screen_v202512301945.tar.gz
作用：部署大屏展示前端的容器（如监控大屏、数据可视化页面）
配置引用：步骤3的 ConfigMap 为该前端提供定制配置。

步骤 9: Service – shandong-alert-rollback-ttl-screen
作用：为大屏前端 Deployment 提供稳定的网络访问入口，类似步骤7。


🎯 整体部署逻辑
隔离环境：先创建NameSpace，确保所有资源归属清晰
注入配置：提前创建ConfigMap编写配置，以便后续前端Deployment使用，避免硬编码
部署后端：部署后端并创建Service，使得后端服务API可用
部署前端：部署工作台和大屏两个独立前端Deployment，它们可能调用后端服务获取数据
对外暴露：为每个前端应用创建独立Service，后续可通过Ingress或负载均衡器将两个站点(工作台和大屏)暴露给用户。


## 技术细节

### 镜像引用digest是个啥?
解释：digest是内容可寻址的哈希(通常是SHA256)，确保镜像唯一性和不可变性，用于固定版本，避免标签漂移。

是什么?
镜像仓库会根据尽享的实际内容(层和配置)计算出一个唯一的SHA256哈希值，这就是digest.
引用镜像时，可以用`镜像名@sha256:abc123...`的形式固定到这本精确版本，而不依赖可变的标签(tag).

为什么用它?
确定性：无论镜像标签后续被覆盖更新，只要用 digest 拉取，得到的一定是同一个内容，彻底杜绝“上次部署好好的，这次却变了”的标签漂移问题。
安全性：结合签名和策略，可以验证镜像内容未经篡改。
生产环境推荐：Kubernetes 部署中，用 digest 代替 :latest 甚至 :v1.0 这类可变标签，能确保部署的可重复性和一致性。

例如：
可变引用：myapp:v20260507（下次标签可能指向新镜像）
固定引用：myapp@sha256:e3b0c44298fc1c...（永远指向同一个镜像）


### 部署YAML编写
例如：

```


```


