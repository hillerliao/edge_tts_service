FROM python:3.9-slim

# 设置工作目录
WORKDIR /app

# 设置环境变量
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1
ENV FLASK_ENV production

# 安装系统依赖
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

# 复制项目文件
COPY requirements.txt ./
COPY config.py ./
COPY run.py ./
COPY app ./app

# 安装Python依赖
RUN pip install --no-cache-dir -r requirements.txt

# 创建非root用户
RUN useradd -m appuser && chown -R appuser:appuser /app
USER appuser

# 暴露端口
EXPOSE 5000

# 启动命令
CMD ["gunicorn", "--bind", "0.0.0.0:5000", "--workers", "4", "run:app"]
