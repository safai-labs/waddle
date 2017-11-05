#!/bin/bash


MAKE=make
QEMU=qemu-system
QEMU_ARCH=x86_64
KERNEL=/boot/vmlinuz-4.14.0-rc6-aifs 
KERNEL_APPEND="console=ttyS0"
ENABLE_KVM="--enable-kvm"
ENABLE_SERIAL="--nographic"

build_rootfs() {
	${MAKE} rootfs
}

boot_kernel() {
	${QEMU}-${QEMU_ARCH} 			 \
		-hda ~/.config/waddle/rootfs.img \
		-kernel ${KERNEL} 		 \
		-append "root=/dev/sda single ${KERNEL_APPEND}"  \
		${ENABLE_KVM} ${ENABLE_SERIAL}
}

boot_kernel
