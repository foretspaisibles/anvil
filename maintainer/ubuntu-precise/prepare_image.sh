### prepare_image.sh -- Prepare Ubuntu Precise Images

# Anvil (https://github.com/michipili/anvil)
# This file is part of Anvil
#
# Copyright © 2015 Michael Grünewald
#
# This file must be used under the terms of the CeCILL-B.
# This source file is licensed as described in the file COPYING, which
# you should have received as part of this distribution. The terms
# are also available at
# http://www.cecill.info/licences/Licence_CeCILL-B_V1-en.txt

: ${dockersubrdir:?}
: ${dockercontextdir:?}

useradd -m -s /bin/zsh anvil

touch /home/anvil/.zshrc

install -d -o anvil /opt/local/var/anvil/conf
install -d -o anvil /opt/local/var/anvil/pkg
install -d -o anvil /opt/local/var/anvil/src

ln -s '/opt/local/var/anvil/conf/ssh' "/home/anvil/.ssh"
ln -s '/opt/local/var/anvil/conf/gnupg' "/home/anvil/.gnupg"
ln -s '/opt/local/var/anvil/conf/gitconfig' "/home/anvil/.gitconfig"
ln -s '/opt/local/var/anvil/conf/gitignore' "/home/anvil/.gitignore"
ln -s '/opt/local/var/anvil/conf/dput.cf' "/home/anvil/.dput.cf"
