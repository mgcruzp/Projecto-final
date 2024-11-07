#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <pthread.h>

// Variable global para controlar el orden de ejecución
int turno = 0;  // Inicialmente el primer hilo debe ejecutarse

// Mutex para proteger la variable turno
pthread_mutex_t mutex = PTHREAD_MUTEX_INITIALIZER;
// Función que será ejecutada por cada hilo
void *contar(void *arg) {
    int hilo_id = (int)arg;  // Obtener el ID del hilo

    // Bucle para esperar su turno
    while (1) {
        pthread_mutex_lock(&mutex);  // Adquirir el mutex para acceder a turno

        if (turno == hilo_id - 1) {  // Si es el turno del hilo, comienza
            printf("Hilo %d iniciado\n", hilo_id);

            // Bucle que cuenta hasta 300
            for (int i = 0; i < 300; i++) {
                usleep(5000); // 5 milisegundos de espera para simular trabajo
            }

            printf("Hilo %d finalizado\n", hilo_id);
            turno++;  // Actualizar el turno para el siguiente hilo
            pthread_mutex_unlock(&mutex);  // Liberar el mutex
            break;  // Terminar el hilo
        }

        pthread_mutex_unlock(&mutex);  // Liberar el mutex si no es su turno
        usleep(1000);
    }

    return NULL;
}
int main() {
    pthread_t hilos[5];  // Array para almacenar los 5 hilos
    int ids[5] = {1, 2, 3, 4, 5};  // Array con los IDs de los hilos

    // Crear 5 hilos
    for (int i = 0; i < 5; i++) {
        if (pthread_create(&hilos[i], NULL, contar, &ids[i]) != 0) {
            printf("Error al crear el hilo\n");
            return 1;
        }
    }

    // Esperar que todos los hilos terminen
    for (int i = 0; i < 5; i++) {
        pthread_join(hilos[i], NULL);
    }

    return 0;
}
