# cd ~/android && ln -s android-dict/run.sh 

# --preserve=REGEX       preserve environment variables matching REGEX
#     --pure             supprime les variables d'environnement existantes
# -C, --container        lance la commande dans un conteneur isolé
# -N, --network          permet aux conteneurs d'accéder au réseau
# -F, --emulate-fhs      pour containers, émule le standard de la hiérarchie
#                        des systèmes de fichiers (FHS)

# Make ./persistent-profile a symlink to the `guix shell ...` result, and
# register it as a garbage collector root, i.e. prevent garbage collection
# during(!) the `guix shell ...` session:
#  --root=./persistent-profile \

# Create environment for the package that the '...' EXPR evaluates to.
# --expression='(list (@ (gnu packages bash) bash) "include")' \
#

export JAVA_HOME=$(guix build openjdk | grep "\-jdk$")
# printf "JAVA_HOME: %s\n" "$JAVA_HOME"

# sudo apt-get install libc6:i386 libncurses5:i386 libstdc++6:i386 lib32z1 libbz2-1.0:i386
# sudo apt-get install libc6 libncurses5 libstdc++6 lib32z1 libbz2-1.0:i386

GXHOME=$(pwd)

# .config/Google/AndroidStudio2023.3/options/ide.general.local.xml
#3:    <option name="browserPath" value="/bin/firefox" />

# /home/bost/android/guix-shell-home/Android/Sdk/platform-tools/adb
# in the guix-shell:
# [env]$ /home/bost/Android/Sdk/platform-tools/adb --version # Android Debug Bridge version 1.0.41
# $ guix install adb # Android Debug Bridge version 1.0.36

# in Android Studio:
# Settings -> Build, Execution, Deployment -> Debugger:
# set "ADB server USB backend" to "libusb"

# create a /usr/bin pointing to the /bin
# --symlink=/usr/bin=/bin \
# --symlink=/usr/bin=bin \

# IDE Settings: File -> Manage IDE Settings -> Import Settings...
# /home/bost/.config/Google/AndroidStudio2023.3/settings.zip

# Initially the $HOME/.config/Google is needed to be shared (via --share) for
# the export of IDE Settings. Then the settings.zip can be copied to
# $GXHOME/.config/Google and only the
# --share=$GXHOME/.config/Google=$HOME/.config/Google is enough.

# [ ! -d   $HOME/.config/Google ] && mkdir -p   $HOME/.config/Google
# [ ! -d $GXHOME/.config/Google ] && mkdir -p $GXHOME/.config/Google

# [ ! -d   $HOME/.local/share/Google ] && mkdir -p   $HOME/.local/share/Google
# [ ! -d $GXHOME/.local/share/Google ] && mkdir -p $GXHOME/.local/share/Google

# [ ! -L ./.ssh ] && ln -s $HOME/.ssh
# [ ! -L ./.bash_history ] && ln -s $HOME/.bash_history

# TODO make the $HOME/bin and $HOME/scm-bin available in the container:
# --expose=$HOME/bin
# --expose=$HOME/scm-bin


# --share=$HOME/.config/Google \
# --share=$GXHOME/.config/Google=$HOME/.config/Google \
# TODO try --expose=$HOME/.ssh instead of --share=$HOME/.ssh

set -x
# --share=SPEC       pour les conteneurs, partage le système de fichier hôte en lecture-écriture en fonction de SPEC
# --expose=SPEC      pour les conteneurs, expose en lecture-seule le système de fichiers hôte en fonction de SPEC
# -S, --symlink=SPEC pour les conteneurs, ajoute des liens symboliques vers le profil selon la SPEC, p. ex. « /usr/bin/env=bin/env ».

# --preserve='^XDG_RUNTIME_DIR$

# android-studio was moved away
# mv ~/android/guix-shell-home/android-studio ~/android/guix-shell-home/___android-studio
# --share=$GXHOME/android-studio=$HOME/android-studio

# '--container' causes wrong time. Preserving:
#     --preserve='^GUIX_LOCPATH$' \
#     --preserve='^TZDIR$' \
# doesn't help. Including tzdata to the manifest.scm doesn't help.

guix shell \
     --verbosity=3 \
     --nesting \
     --emulate-fhs \
     --pure \
     --container \
     --network \
     --no-cwd \
     --manifest=manifest.scm \
     --preserve='^TERM$' \
     --preserve='^JAVA_HOME$' \
     --preserve='^DISPLAY$'    --expose=/dev \
     --preserve='^DBUS_'       --expose=/var/run/dbus \
     --preserve='^XAUTHORITY$' --expose=$XAUTHORITY \
     --preserve='^XDG_' \
     --expose=/sys \
     --expose=/run \
     --share=.=$HOME \
     --share=$HOME/.ssh \
     --share=$HOME/.bash_history \
     -- bash
