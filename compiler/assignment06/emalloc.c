#include <stdlib.h>
#include <stdio.h>
#ifndef __TURBOC__  
#include <unistd.h>
#endif
/* ���ÿ�������ڴ��Ƿ�ɹ�
 */
void *smalloc(size_t size)
{
    static char msg[] = "�������ڴ�ݽ�\n";
    char* retval = (char *)malloc((unsigned)size);

    if(retval == 0) {
	/* fprintf might call malloc(), so... */
	write(2, msg, sizeof(msg));  /* ��ӡ���������
		(file descriptor is 2) */
	exit(-1);
    }
    return retval;
}

void sfree(void *x)
{
  free (x);
}
