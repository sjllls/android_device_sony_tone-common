#!/vendor/bin/sh

# Copyright (C) 2016 Sony Mobile Communications Inc.

src_dir=/data/crashdump
target_dir=/data/media/0/CrashDump
partial_tlcore_dir=/data/crashdata
ls=/vendor/bin/ls
cp=/vendor/bin/cp
rm=/vendor/bin/rm
mkdir=/vendor/bin/mkdir
chmod=/vendor/bin/chmod
chown=/vendor/bin/chown
restorecon=/vendor/bin/restorecon
postdumper=/vendor/bin/post_dumper
grep="toybox_vendor grep"

variant=`getprop ro.build.type`

if [ "$variant" == "userdebug" ]; then
#   $mkdir -m 775 $target_dir
#   $chown media_rw:media_rw $target_dir
#   $chmod 775 $target_dir
#   $restorecon -RF $target_dir
#   $restorecon -RF $partial_tlcore_dir
    $postdumper -d $target_dir
    $postdumper -m

    if [ -e "${src_dir}" ] && [ -e "${target_dir}" ] && [ -e "${partial_tlcore_dir}" ]; then
        for i in $(ls ${src_dir} | $grep -E 'crash|lastdump'); do
            if [ "$i" = "crashdata" ]; then
                echo "Moving $src_dir/$i to $partial_tlcore_dir\n"
                $cp -a $src_dir/$i/* $partial_tlcore_dir
            else
                echo "Moving $src_dir/$i to $target_dir\n"
                $cp -a $src_dir/$i $target_dir
                if [ $? -eq 0 ] ; then
                    $rm -r $src_dir/$i
                fi
            fi
        done
        for i in $(ls ${src_dir} | $grep -E 'anr|dropbox|log|tombstones'); do
            echo "Deleting dump files in $src_dir/$i/\n"
            $rm -r $src_dir/$i/*
        done
    fi
fi
