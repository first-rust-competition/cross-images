.PRECIOUS: FRCUpdateSuite_%.zip
FRCUpdateSuite_%.zip:
	wget -q "http://download.ni.com/support/softlib/first/frc/FileAttachments/FRCUpdateSuite_$*.zip"

.PRECIOUS: sysroot-%
sysroot-%: FRCUpdateSuite_%.zip
	./extract-image.sh FRCUpdateSuite_$*.zip sysroot-$*

%: sysroot-%
	sudo docker build -t firstrustcompetition/cross:$* -f Dockerfile sysroot-$*
