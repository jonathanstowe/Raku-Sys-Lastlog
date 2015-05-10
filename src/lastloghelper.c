/*
 * Helper library for Sys::Lastlog
*/

#include <utmp.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <stdio.h>
#include <pwd.h>
#include <unistd.h>

#ifdef USE_LASTLOG_H
#include <lastlog.h>
#endif

int get_lastlog_fd(void);
char *lastlog_path(void);

extern struct lastlog *getllent(void)
{

   static struct lastlog llent;

   int ll_fd;

   if ( (ll_fd =  get_lastlog_fd() ) == -1 )
   {
     return( ( void *)0);
   }

   if(read( ll_fd,&llent, sizeof( struct lastlog )) != sizeof( struct lastlog))
   {
      close(ll_fd);
      return ( (void *)0 );
   }
   else
   {
      return ( &llent );
   }
}

extern struct lastlog *getlluid(int uid)
{
  static struct lastlog llent;
  int ll_fd;

  off_t where;

  if ( (ll_fd =  get_lastlog_fd() ) == -1 )
  {
     return( ( void *)0);
  }


  where = lseek(ll_fd,0, SEEK_CUR);

  lseek(ll_fd, (off_t)(uid * sizeof( struct lastlog)), SEEK_SET);


  if(read( ll_fd,&llent, sizeof( struct lastlog )) != sizeof( struct lastlog))
  {
      lseek(ll_fd,where, SEEK_SET );
      return ( (void *)0 );
  }
  else
  {
      lseek(ll_fd,where, SEEK_SET );
      return ( &llent );
  }
}

int get_lastlog_fd(void)
{

   static int ll_fd = -1;

   if ( ll_fd == -1 )
   {
     ll_fd = open((char *)lastlog_path(),O_RDONLY);
   }

   return(ll_fd);
}

char *lastlog_path(void)
{
   return _PATH_LASTLOG;
}

extern void setllent(void)
{
   int ll_fd;

   if ((ll_fd =  get_lastlog_fd()) != -1)
   {
      lseek(ll_fd,0, SEEK_SET);
   }     
}

extern struct lastlog *getllnam(char *logname)
{
    struct passwd *pwd;
    struct lastlog *llent;

    if((pwd = getpwnam(logname)))
    {
      llent = getlluid(pwd->pw_uid);
    }
    else
    {
      llent = (void *)0;
    }
	 return llent;
}

