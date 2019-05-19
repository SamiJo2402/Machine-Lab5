run: askcards_auto.s askcards_man.s check_winner.s dealcards.s draw.s main.c modulo.s shuffle.s
	gcc -o run askcards_auto.s askcards_man.s check_winner.s dealcards.s draw.s main.c modulo.s shuffle.s
clean:
	rm run

