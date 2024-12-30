# Sử dụng image cơ bản
FROM ubuntu:22.04

# Cài đặt các công cụ cần thiết
RUN apt-get update && apt-get install -y \
    openssh-server \
    sudo \
    && mkdir /var/run/sshd

# Thêm người dùng mới để sử dụng SSH
RUN useradd -m -s /bin/bash admin && echo "admin:admin" | chpasswd && adduser admin sudo

# Cấu hình SSH để cho phép đăng nhập bằng mật khẩu
RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config \
    && sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config

# Cấp quyền cho script entrypoint
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Expose cổng 22 để SSH
EXPOSE 22

# Khởi động SSH server khi container chạy
CMD ["/entrypoint.sh"]
