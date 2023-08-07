#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

int main(int argc,char **argv)
{
	int parent_fd[2];
	int child_fd[2];
	char buff[64];
	pipe(parent_fd);
	pipe(child_fd);
	//parent process
	if(fork())
	{
		close(parent_fd[0]);
		write(parent_fd[1],"ping",4);
		close(child_fd[1]);
		read(child_fd[0],buff,4);
		printf("%d: received %s\n",getpid(),buff);
		exit(0);
	}
	//child process
	else
	{
		close(parent_fd[1]);
		read(parent_fd[0],buff,4);
		printf("%d: received %s\n",getpid(),buff);
		close(child_fd[0]);
		write(child_fd[1],"pong",4);
		exit(0);
	}

}