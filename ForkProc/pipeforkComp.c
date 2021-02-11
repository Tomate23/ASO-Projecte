#include <sys/types.h>
#include <wait.h>
#include <unistd.h>
#include <stdio.h>

main()
{
	pid_t idProceso;
    pid_t PPID=getppid(); /*Pilla el proceso padre del padre*/

	int estadoHijo;
	int descriptorTuberia[2];
	char buffer[100];

	if (pipe (descriptorTuberia) == -1)
	{
		perror ("No se puede crear Tuberia");
		exit (-1);
	}
	
	idProceso = fork();

	if (idProceso == -1)
	{
		perror ("No se puede crear proceso");
		exit (-1);
	}

	if (idProceso == 0)
	{
		close (descriptorTuberia[1]);
		read (descriptorTuberia[0], buffer, 5);
        printf ("ID Proceso hijo : \"%d\"\n", getppid()); /*getppid() pilla el id del proceso cuando la fork() == 0, es decir el child*/
		printf ("Hijo  : Recibido \"%s\"\n", buffer);
		exit (0);
	}
    
	if (idProceso > 0)
	{
		close (descriptorTuberia[0]);
        printf ("Proceso padre del padre : \"%d\"\n", PPID);
		printf ("Padre : Envio \"Hola\"\n");
		strcpy (buffer, "Hola");
		write (descriptorTuberia[1], buffer, strlen(buffer)+1);
		wait (&estadoHijo);
        printf ("ID Proceso ppdadre : \"%d\"\n", idProceso);
		exit (0);
	}
}
