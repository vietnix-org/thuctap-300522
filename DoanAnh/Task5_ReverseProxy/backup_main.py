import os
import time
import datetime
import pipes
from pickle import FALSE


BACKUP_PATH = '/home/wordpress/backup'
BACKUP_DATE = '%d%m%Y%-H%M%S'
DB_HOST = '176.'
DB_USER = 'root'
DB_NAME = 'training'
DAY_KEEP_BACKUP = 3
TODAYBACKUPPATH = BACKUP_PATH + '/' + BACKUP_DATE

# get today's date and time
today = datetime.datetime.now().strftime(BACKUP_DATE)
for f in os.listdir(BACKUP_PATH):
    if os.stat(os.path.join(BACKUP_PATH,f)).st_mtime < (now - 3 * 86400):
        os.remove(f)              
            
# Code for checking if you want to take single database backup or assinged multiple backups in DB_NAME.
print ("checking for databases names file.")
if os.path.exists(DB_NAME):
    file1 = open(DB_NAME)
    multi = 1
    print ("Databases file found...")
    print ("Starting backup of all databases listed in file " + DB_NAME)
else:
    print ("Databases file not found...")
    print ("Starting backup of database " + DB_NAME)
    multi = 0
    
    
# Starting actual database backup process
if multi:
    in_file = open(DB_NAME,"r")
    flength = len(in_file.readlines())
    in_file.close()
    p = 1
    dbfile = open(DB_NAME,"r")
 
    while p <= flength:
       db = dbfile.readline()   # reading database name from file
       db = db[:-1]         # deletes extra line
       dumpcmd = "mysqldump -h " + DB_HOST + " -u " + DB_USER + " " + db + " > " + pipes.quote(TODAYBACKUPPATH) + "/" + db + ".sql"
       os.system(dumpcmd)
       gzipcmd = "gzip " + pipes.quote(TODAYBACKUPPATH) + "/" + db + ".sql"
       os.system(gzipcmd)
       p = p + 1
    dbfile.close()
else:
   db = DB_NAME
   dumpcmd = "mysqldump -h " + DB_HOST + " -u " + DB_USER + " " + db + " > " + pipes.quote(TODAYBACKUPPATH) + "/" + db + ".sql"
   os.system(dumpcmd)
   gzipcmd = "gzip " + pipes.quote(TODAYBACKUPPATH) + "/" + db + ".sql"
   os.system(gzipcmd)
 
print ("")
print ("Backup script completed")
print ("Your backups have been created in '" + TODAYBACKUPPATH + "' directory")
