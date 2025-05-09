# ☕ Deploying a Java Web Application (WAR) with Apache Tomcat and Docker

This guide provides step-by-step instructions to create, deploy, and run a Java web application using a standard servlet framework (like JSP/Servlet or Spring) with **Apache Tomcat** — first natively, then inside Docker.

---

## 🧱 STEP 1: Build Java Web App Locally

### 1. Create Maven project

```bash
mvn archetype:generate -DgroupId=com.example \
    -DartifactId=my-webapp \
    -DarchetypeArtifactId=maven-archetype-webapp \
    -DinteractiveMode=false

cd my-webapp
```

### 2. Update `pom.xml` for servlet API

Add inside `<dependencies>`:
```xml
<dependency>
  <groupId>javax.servlet</groupId>
  <artifactId>javax.servlet-api</artifactId>
  <version>4.0.1</version>
  <scope>provided</scope>
</dependency>
```

### 3. Create basic servlet

Create file: `src/main/java/com/example/HelloServlet.java`

```java
package com.example;

import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;

public class HelloServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        response.setContentType("text/html");
        PrintWriter out = response.getWriter();
        out.println("<h1>Hello from Java Servlet!</h1>");
    }
}
```

Map it in `src/main/webapp/WEB-INF/web.xml`:

```xml
<web-app>
  <servlet>
    <servlet-name>HelloServlet</servlet-name>
    <servlet-class>com.example.HelloServlet</servlet-class>
  </servlet>
  <servlet-mapping>
    <servlet-name>HelloServlet</servlet-name>
    <url-pattern>/hello</url-pattern>
  </servlet-mapping>
</web-app>
```

---

## 🏗️ STEP 2: Package the WAR File

```bash
mvn clean package
```

This creates `target/my-webapp.war`

---

## 🖥️ STEP 3: Deploy on Local Apache Tomcat

### 1. Install Tomcat

```bash
sudo apt update
sudo apt install tomcat9 -y
```

### 2. Deploy WAR file

```bash
sudo cp target/my-webapp.war /var/lib/tomcat9/webapps/
```

### 3. Restart Tomcat

```bash
sudo systemctl restart tomcat9
```

### 4. Test in browser

```
http://localhost:8080/my-webapp/hello
```

---

## 🐳 STEP 4: Deploy with Docker (Tomcat)

### 1. Create Dockerfile

```dockerfile
FROM tomcat:9.0-jdk17
COPY target/my-webapp.war /usr/local/tomcat/webapps/
EXPOSE 8080
```

### 2. Build and run Docker image

```bash
docker build -t java-webapp-tomcat .
docker run -d -p 8080:8080 java-webapp-tomcat
```

### 3. Access in browser

```
http://localhost:8080/my-webapp/hello
```

---

## ✅ Summary

| Step | Purpose |
|------|---------|
| Maven | Build WAR package |
| Tomcat (local) | First test deployment |
| Docker (Tomcat image) | Containerized deployment |

This setup is ideal for testing Java web apps both natively and in Dockerized environments.

