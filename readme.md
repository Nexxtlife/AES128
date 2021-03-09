### Implementacja AES w ramach praktyk Dawid M

Uwagi do testbencha:
    
    1. nazwy sygnałów w tesbenchu powinny różnić się od nazw sygnałów w DUT (np. poprzez dodanie _tb na końcu) - dobra proaktyka
    2. clk_process powinien mieć instrukcje wait do zatrzymania procesu - dla wygody
    3. nie rozmiem sposobu sterowani sygnałem reset w procesie sim_proc - zazwyczaj dane zmieniają się po zwolnieniu dut z resetu, co proawda nie powinno to wpływac na funkjonalność lecz należy się trzymać przyjętych reguł wysterowywania sygnałów.
    4. sygnał done oraz ciphertext sie nie ustawiały na odpwiednie wartości


Skrypt symulacji:

W lokalizacji projektu dorzuciłem Ci skrypt sim_setup.tcl do automatycznego uruchamiania Modelsima.
Skrypt uruchamia się w dowolnej powłoce lub linii komend poprzez wywołanie:
> $ modelsim -do sim_setup.tcl  

lub z okna transcript w modelsim (ważna abyś sie znajdował w lokalizacji, w której jest skrypt):

> source sim_setup.tcl

Oprócz skryptu stworzyłem Ci jeszcze szablon testbencha, który według mnie będzie przyjemniajszy w tworzeniu i edycji nowych przypadków testowych. Testbench znajduje się w lokalizacji: *'testbench/aes_enc_tb.vhd'*

Zadania:

    1. Zapoznaj się ze skryptem oraz strukturą testbencha w sposób taki, abyśmy mogli przejśc do pisania przypadków testowych - w razie pytań jest dostępny na Discord
    2. Dodaj przypadek testowy sprawdzenia pierwszego wektora testowego - łącznie ze sprawdzeniem w kodzie czy wartość zwócona przez DUT zgadza się z przewidywany wynikiem (checker process)
    3. Wykonał łączenie gałęzi  do mastera i opisz zmiany(MR)

Oczywiście zakładam jeszcze że DUT może posidać pewne błędy - po to piszemy testbenchę żeby tos sprawdzić i je usunąć.



