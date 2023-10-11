#Configuracion pines GPIO
PIN_CAR_GREEN=2
PIN_CAR_AMBER=1
PIN_CAR_RED=0
PIN_PED_GREEN=4
PIN_PED_RED=3
PIN_BUTTON=8

#Configuracion codigos
CODE_CAR_GREEN=2
CODE_CAR_AMBER=1
CODE_CAR_RED=0
CODE_PED_GREEN=4
CODE_PED_RED=3

#Configuracion tienpos
DELAY_CAR_AMBER=1
DELAY_CAR_RED=1
DELAY_CAR_GREEN=1
DELAY_PED_RED=3
DELAY_PED_GREEN=1
DELAY_FLASH=0.25
#Funcion configuracion pines GPIO
configurar_pines(){
gpio mode $PIN_CAR_GREEN out
gpio mode $PIN_CAR_AMBER out
gpio mode $PIN_CAR_RED out
gpio mode $PIN_PED_GREEN out
gpio mode $PIN_PED_RED out
gpio mode $PIN_BUTTON in
gpio mode $PIN_BUTTON up

}
#Funcion estado inicial semaforo
iniciar_semaforos(){
gpio write $PIN_CAR_GREEN 1
gpio write $PIN_CAR_AMBER 0
gpio write $PIN_CAR_RED 0
gpio write $PIN_PED_GREEN 0
gpio write $PIN_PED_RED 1
}

#Funcion cambiar el estado de los semaforos
cambiar_semaforos(){
gpio write $PIN_CAR_GREEN 0
gpio write $PIN_CAR_AMBER 1

/bin/sleep $DELAY_CAR_AMBER

gpio write $PIN_CAR_AMBER 0
gpio write $PIN_CAR_RED 1

/bin/sleep $DELAY_CAR_RED

gpio write $PIN_PED_GREEN 1
gpio write $PIN_PED_RED 0

/bin/sleep $DELAY_PED_RED

for i in $(seq 0 5); do
	gpio write $PIN_PED_GREEN 0
	gpio write $PIN_CAR_AMBER 0

	/bin/sleep $DELAY_FLASH
	
	gpio write $PIN_CAR_AMBER 1
	gpio write $PIN_PED_GREEN 1

	/bin/sleep $DELAY_FLASH
done
gpio write $PIN_PED_GREEN 0
gpio write $PIN_CAR_AMBER 0
gpio write $PIN_PED_RED 1
gpio write $PIN_CAR_RED 0
gpio write $PIN_CAR_GREEN 1

/bin/sleep $DELAY_CAR_GREEN

}

configurar_pines

iniciar_semaforos

while true; do
	while [ $(gpio read $PIN_BUTTON) -eq 1 ]; do
		/bin/sleep 0.1 
	done
	
	cambiar_semaforos
done
