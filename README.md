## Dev machine build -  
A playbook composed of several roles to build my dev machine  
from just a fresh ubuntu install.  

### Need to do a few things first -  
Install the ubuntu system.
I usually do a light install with the net installer.  


#### Need git and ansible to get going -  
These need to be installed first so you can get the  
playbook and then run it.
I considered a network boot with image built from packer but I  
don't do this often enough to make that worth it.  
#### The git configuration is in the playbook -  
Variables for it configured in group_vars/all/all.yml

#### Script gets all the vim add ons -  
If you want to change them, edit the script   
roles/vim/files/vimplug_update.sh

#### Key configs are under version control -  
.bashrc, .vimrc.
Can always change locally, but anything you want a part of the  
standard setup should be committed.  

#### Run the playbook with sudo -  
The playbook will use sudo/regular user but needs to have  
sudo permission for lots of tasks, so run:
sudo ansible-playbook devbuild.yml

### Getting dropbox going is not part of the playbook -  
Also something a lot of people probably don't use.
Since this requires some GUI work it is best to run afterwards.  
dropbox start -i && dropbox autostart y  

