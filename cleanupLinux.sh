#!/bin/bash

# Установить необходимые пакеты
# sudo apt-get install bleachbit deborphan

GREEN="\033[1;32m"
RED="\033[0;31m"
YELLOW="\033[1;33m"
ENDCOLOR="\033[0m"

OLDCONF=$(dpkg -l | grep "^rc" | awk '{print $2}')
CURKERNEL=$(uname -r | sed 's/-*[a-z]//g' | sed 's/-386//g')
LINUXPKG="linux-(image|headers|ubuntu-modules|restricted-modules)"
METALINUXPKG="linux-(image|headers|restricted-modules)-(generic|i386|server|common|rt|xen)"
OLDKERNELS=$(dpkg -l | awk '{print $2}' | grep -E $LINUXPKG | grep -vE $METALINUXPKG | grep -v $CURKERNEL)

if [ $USER != root ]; then
  echo -e $RED"Вы должны быть root!\n"$ENDCOLOR
  exit 0
fi

echo
echo -e $GREEN"-----------------------------"$ENDCOLOR
echo -e $GREEN"---Чистка пакетов запущена---"$ENDCOLOR
echo -e $GREEN"-----------------------------"$ENDCOLOR

echo -e $YELLOW"Bleachbit - приложения"$ENDCOLOR
bleachbit -c adobe_reader.cache \
             adobe_reader.mru \
             adobe_reader.tmp \
             amsn.cache \
             amsn.chat_logs \
             amule.logs \
             amule.temp \
             apt.autoclean \
             apt.autoremove \
             apt.clean \
             apt.package_lists \
             audacious.cache \
             audacious.log \
             audacious.mru \
             beagle.cache \
             beagle.index \
             beagle.logs \
             chromium.cache \
             chromium.cookies \
             chromium.dom \
             chromium.form_history \
             chromium.history \
             chromium.passwords \
             chromium.search_engines \
             chromium.session \
             chromium.sync \
             chromium.vacuum \
             d4x.history \
             deepscan.backup \
             deepscan.ds_store \
             deepscan.thumbs_db \
             deepscan.tmp \
             easytag.history \
             easytag.logs \
             elinks.history \
             emesene.cache \
             emesene.logs \
             epiphany.cache \
             epiphany.cookies \
             epiphany.passwords \
             epiphany.places \
             evolution.cache \
             exaile.cache \
             exaile.downloaded_podcasts \
             exaile.log \
             filezilla.mru \
             firefox.backup \
             firefox.cache \
             firefox.cookies \
             firefox.crash_reports \
             firefox.dom \
             firefox.forms \
             firefox.passwords \
             firefox.session_restore \
             firefox.site_preferences \
             firefox.url_history \
             firefox.vacuum \
             flash.cache \
             flash.cookies \
             gedit.recent_documents \
             gftp.cache \
             gftp.logs \
             gimp.tmp \
             gl-117.debug_logs \
             gnome.run \
             gnome.search_history \
             google_chrome.cache \
             google_chrome.dom \
             google_chrome.form_history \
             google_chrome.search_engines \
             google_chrome.vacuum \
             google_earth.temporary_files \
             google_toolbar.search_history \
             gpodder.cache \
             gpodder.vacuum \
             gwenview.recent_documents \
             hippo_opensim_viewer.cache \
             hippo_opensim_viewer.logs \
             java.cache \
             kde.cache \
             kde.recent_documents \
             kde.tmp \
             konqueror.cookies \
             konqueror.current_session \
             konqueror.url_history \
             libreoffice.cache \
             libreoffice.history \
             liferea.cache \
             liferea.cookies \
             liferea.vacuum \
             links2.history \
             midnightcommander.history \
             miro.cache \
             miro.logs \
             nautilus.history \
             nexuiz.cache \
             octave.history \
             openofficeorg.cache \
             openofficeorg.recent_documents \
             opera.cache \
             opera.cookies \
             opera.dom \
             opera.form_history \
             opera.history \
             opera.passwords \
             opera.session \
             opera.vacuum \
             pidgin.cache \
             pidgin.logs \
             realplayer.cookies \
             realplayer.history \
             realplayer.logs \
             recoll.index \
             rhythmbox.cache \
             screenlets.logs \
             seamonkey.cache \
             seamonkey.chat_logs \
             seamonkey.cookies \
             seamonkey.download_history \
             seamonkey.history \
             secondlife_viewer.Cache \
             secondlife_viewer.Logs \
             skype.chat_logs \
             skype.installers \
             sqlite3.history \
             system.cache \
             system.custom \
             system.desktop_entry \
             system.localizations \
             system.recent_documents \
             system.rotated_logs \
             system.tmp \
             system.trash \
             thumbnails.cache \
             thunderbird.cache \
             thunderbird.cookies \
             thunderbird.index \
             thunderbird.passwords \
             thunderbird.vacuum \
             transmission.blocklists \
             tremulous.cache \
             vim.history \
             vlc.mru \
             vuze.backup \
             vuze.cache \
             vuze.logs \
             vuze.stats \
             vuze.temp \
             warzone2100.logs \
             wine.tmp \
             winetricks.temporary_files \
             x11.debug_logs \
             xine.cache \
             yum.clean_all \
             yum.vacuum \
# | grep -v "debug"

echo -e $YELLOW"Clean: Удаление кэша apt..."$ENDCOLOR
apt-get -y clean

echo -e $YELLOW"Autoclean: Удаление частичных пакетов..."$ENDCOLOR
apt-get -y autoclean

echo -e $YELLOW"Удаление старых конфигов..."$ENDCOLOR
apt-get -y purge $OLDCONF

echo -e $YELLOW"Deborphan: Удаление незадействованных пакетов..."$ENDCOLOR
while [ -n "`deborphan`" ]; do
    deborphan
    echo
    apt-get -y purge `deborphan`
done

echo -e $YELLOW"Удаление старых ядер..."$ENDCOLOR
apt-get -y purge $OLDKERNELS

echo -e $YELLOW"Autoremove: Удаление пакетов, установленных по зависимостям и которые больше не нужны..."$ENDCOLOR
apt-get -y autoremove --purge

echo -e $YELLOW"Очистка корзины пользователей..."$ENDCOLOR
rm -rf /home/*/.local/share/Trash/*/**
rm -rf /root/.local/share/Trash/*/**

echo -e $GREEN"------------------------"$ENDCOLOR
echo -e $GREEN"---Очистка завершена!---"$ENDCOLOR
echo -e $GREEN"------------------------"$ENDCOLOR
echo
