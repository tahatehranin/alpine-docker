# استفاده از Alpine به عنوان پایه
FROM alpine:latest

# بروزرسانی و نصب OpenSSH Server
RUN apk add --no-cache openssh

# ایجاد کلیدهای host (الزامی برای شروع SSH)
RUN ssh-keygen -A

# ایجاد یک کاربر (مثلاً "tunnel") با رمز عبور ساده (برای آزمایش)
RUN adduser -D tunnel && echo "tunnel:password" | chpasswd

# (اختیاری) فعال کردن ورود root با رمز - در صورت نیاز خط زیر را از کامنت خارج کنید
# RUN echo "root:rootpassword" | chpasswd

# ایجاد فایل sshd_config سفارشی با پورت ۸۰ و تنظیمات مورد نیاز
RUN echo "Port 80" >> /etc/ssh/sshd_config && \
    echo "ListenAddress 0.0.0.0" >> /etc/ssh/sshd_config && \
    echo "PermitRootLogin yes" >> /etc/ssh/sshd_config && \
    echo "PubkeyAuthentication yes" >> /etc/ssh/sshd_config && \
    echo "PasswordAuthentication yes" >> /etc/ssh/sshd_config && \
    echo "ChallengeResponseAuthentication no" >> /etc/ssh/sshd_config && \
    echo "UsePAM yes" >> /etc/ssh/sshd_config && \
    echo "X11Forwarding no" >> /etc/ssh/sshd_config && \
    echo "PrintMotd no" >> /etc/ssh/sshd_config && \
    echo "AcceptEnv LANG LC_*" >> /etc/ssh/sshd_config && \
    echo "Subsystem sftp /usr/lib/ssh/sftp-server" >> /etc/ssh/sshd_config

# پورت ۸۰ را expose می‌کنیم
EXPOSE 80

# اجرای SSH Daemon در foreground
CMD ["/usr/sbin/sshd", "-D", "-e"]
