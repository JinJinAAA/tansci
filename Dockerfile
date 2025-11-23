# 使用 Maven 官方镜像作为构建阶段的基础镜像。
# 使用通用且稳定的标签 '3-jdk-17'，确保 Docker Hub 能够找到它，避免精确标签失效的问题。
FROM maven:3-jdk-17 AS build

# 设定工作目录
WORKDIR /app

# 复制 pom.xml 文件以利用 Docker 缓存机制
# 注意: 我们假设 pom.xml 在根目录
COPY pom.xml .

# 复制 Maven Wrapper 文件（如果存在的话，如果不存在，这一步忽略）
COPY .mvn .mvn

# 下载项目依赖，以确保后续的代码修改不会重复下载依赖
RUN mvn dependency:go-offline -B

# 复制所有源代码
COPY src src/

# 执行 Maven 构建命令，生成可执行的 JAR 文件
# -DskipTests 跳过测试
RUN mvn clean install -DskipTests

# --------------------------------------------------------------------------------
# 第二阶段：运行阶段 (更小的运行环境)
# --------------------------------------------------------------------------------

# 使用 Eclipse Temurin JRE 镜像作为运行时的基础镜像，这是一个轻量级且常用的 JDK/JRE 提供商
FROM eclipse-temurin:17-jre-alpine

# 设定工作目录
WORKDIR /app

# 将第一阶段构建生成的 JAR 文件复制到运行镜像中
# JAR 文件位于 build 阶段的 /app/target 目录下
# 注意：你需要根据你的 pom.xml 中 <finalName> 的配置来调整 JAR 文件的名称。
# 如果没有指定 finalName，Maven 默认使用 artifactId-version.jar。
# 我们使用通配符确保可以找到它。
COPY --from=build /app/target/*.jar app.jar

# 暴露 Spring Boot 默认端口
EXPOSE 8080

# 启动 Spring Boot 应用
# Render 会执行这个命令来运行您的服务
ENTRYPOINT ["java", "-jar", "app.jar"]
