# Waddle makefile segment 
# Used to generate rootfs and other waddle bits and pieces
#

ifeq ($(V),)
  Q := @
else
  Q := 
endif

WADDLEDIR   	  ?= ~/.config/waddle

ROOTFS_LOCALNAME  ?=
ROOTFS_IMAGE  	  ?= ${WADDLEDIR}/rootfs${ROOTFS_LOCALNAME}.img
ROOTFS_IMAGE_SIZE ?= 1g
ROOTFS_MOUNTDIR   ?= ${WADDLEDIR}/root${ROOTFS_LOCALNAME}
ROOTFS_FS         ?= ext2
ROOTFS_ARCH	  ?= amd64
DEBIAN            ?= stretch
DEBOOTSTRAP       ?= debootstrap

#
# XXX: take care of the mkfs here, really should *not* force it 
# unless we know that the target is actually safe to format.
#
MKFS 		  ?= mkfs.${ROOTFS_FS} -F

MKDIR_P 	  = mkdir -p
QEMUIMG 	  = qemu-img
MOUNT             = mount
SUDO              = sudo
UMOUNT 		  = umount
RMDIR  		  = rmdir -f 

.waddle.default:

mkrootfs:
	$(Q)$(MKDIR_P) ${ROOTFS_MOUNTDIR} $(shell dirname ${ROOTFS_IMAGE})
	$(Q)$(RM) ${ROOTFS_IMAGE}
	$(Q)$(QEMUIMG) create ${ROOTFS_IMAGE} ${ROOTFS_IMAGE_SIZE}
	$(Q)$(MKFS) ${ROOTFS_IMAGE}
	$(Q)$(SUDO) $(MOUNT) -o loop ${ROOTFS_IMAGE} ${ROOTFS_MOUNTDIR}
	$(Q)$(SUDO) $(DEBOOTSTRAP) --arch $(ROOTFS_ARCH) $(DEBIAN) ${ROOTFS_MOUNTDIR}
	$(Q)$(SUDO) $(UMOUNT) ${ROOTFS_MOUNTDIR}
	$(Q)$(SUDO) $(RMDIR) ${ROOTFS_MOUNTDIR}

.PHONY: rootfs .waddle.default
