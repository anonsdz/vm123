FROM ubuntu:22.04

# Cập nhật và cài đặt các gói cần thiết
RUN apt-get update && apt-get install -y \
    openssh-server \
    sudo && \
    mkdir /var/run/sshd

# Tạo người dùng và đặt mật khẩu
RUN useradd -m -s /bin/bash admin && echo "admin:admin" | chpasswd && adduser admin sudo

# Cấu hình SSH để chạy ở chế độ nền
RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config && \
    sed -i 's@session    required     pam_loginuid.so@session    optional     pam_loginuid.so@g' /etc/pam.d/sshd && \
    echo "export VISIBLE=now" >> /etc/profile

# Mở cổng SSH
EXPOSE 22

# Lệnh khởi động
CMD ["/usr/sbin/sshd", "-D"]
