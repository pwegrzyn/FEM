function wegrzynMES12(f, g0, u1, n)
% Funkcja to rozwiazuje i rysuje rozwiazanie konkretnego rownania roznicznkowego drugiego
% rzedu z warunkami Robin'a i Dirichleta przy pomocy metody elementow skonczonych

% spawdzamy parzystosc n
reszta = mod(n, 2);

% oblicz odleglosc pomiedzy dwoma sasiednimi punktami siatki (uwaga: dlugosc przedzialu
% to w tym przypadku 2, a nie 1 jak w poprzednich przykladach, dlatego dwojka w liczniku)

h = 2/n;

% oblicz wartosci kolejnych elementow macierzy glownej ukladu odpowiednio znajdujace sie: 
% nad przekatna (P3), na przekatnej (P2), pod przekatna (P1) (poniewaz funkcja k jest 'klamrowa' to
% zmueszeni jestesmy do napisania osobnych wzorow dla kazdego przedzialu: A - [0,1) oraz B - [1,2]

% [0,1) - lewy przedzial
P1lewy = -1/h + h/6;
P2lewy =  2/h + 2*h/3;
P3lewy = -1/h + h/6;

% [1,2] - prawy przedzial
P1prawy = -1/h + h/3;
P2prawy =  2/h + 4*h/3;
P3prawy = -1/h + h/3;

% wypelnij macierz glowna ukladu (uwaga: rozrozniamy dwoma osobne przypadku: gdy n jest nieparzyste
% oraz gdy n jest parzyste, w tym pierwszym przypadku musimy odpowiednio zmodyfikowac srodkowy element na
% przekatnych bocznych oraz 2 srodkowe element na przekatne glownej, z kolei w drugim przypadku musimy dodac
% odpowiedni element na srodkowym element przekatnej glownej), wynika to wsztstko z faktu, ze
% funkcje 'zabkowe', ktore wybralismy w tej metodzie moga zostac przeciete przez wartosc x = 1, w ktorej
% to nasza funkcja k zmienia postac

% przygotowujemy nasza macierz glowna
macierz = zeros(n);

% gdy n jest nieparzyste wypelniamy w ten sposob:
if (reszta != 0)

  mid = (n + 1) / 2;
  
  for k = 1 : mid - 1
  
    macierz(k + 1, k) = P1lewy;
    macierz(k, k) = P2lewy;
    macierz(k, k + 1) = P3lewy; 
    
  end
  
  for k = mid + 2 : n
  
    macierz(k, k - 1) = P1prawy;
    macierz(k, k) = P2prawy;
    macierz(k - 1, k) = P3prawy; 
    
  end
  % wstawiamy przypadki graniczne
  macierz(1, 1) = macierz(1, 1) / 2 + 1;
  macierz(mid, mid) = 2/h + 3*h/4;
  macierz(mid + 1, mid) = -1/h + h/4;
  macierz(mid, mid + 1) = -1/h + h/4;
  macierz(mid + 1, mid + 1) = 2/h + 5*h/4;
  
%w przeciwnym razie n jest parzyste i wypelniamy w ten sposob:

else

  for k = 1 : n / 2
  
    macierz(k + 1, k) = P1lewy;
    macierz(k, k) = P2lewy; 
    macierz(k, k + 1) = P3lewy; 
    
  end
  
  for k = n / 2 + 2 : n
    macierz(k, k - 1) = P1prawy;
    macierz(k, k) = P2prawy;
    macierz(k - 1, k) = P3prawy;
    
  end
  % wstawiamy przypadki graniczne
  macierz(1, 1) = macierz(1, 1) / 2 + 1;
  macierz(n / 2 + 1, n / 2 + 1) = 2/h + h;
  
end

% wypelnij wektor wyrazow wolnych prawej strony, w tym przypadku calki liczymy
% metoda Simpsona
for k = 1 : n
    wektor_pr(k, 1) = f(2 * (k - 1) / n) * 4 * h / 3;
end

% modyfikujemy wartosci graniczne, tj dla k = 0 oraz dla k = n
wektor_pr(1, 1) = wektor_pr(1, 1) + g0;
wektor_pr(n, 1) = wektor_pr(n, 1) - u1 * P1prawy;

% rozwiaz uklad przy pomocy domyslnego solvera: macierz * wynik = wektor_pr
wynik = macierz \ wektor_pr;

% przypisz wartosci funkcji
wartosci = zeros(1, n + 1);
wartosci(1 : n) = wynik;
% uwzglednij warunek Dirichleta
wartosci(n + 1) = u1;

% stworz wektor punktow w celu pozniejszego naszkicowania wykresu
punkty = 0 : 2/n : 2;

% narysuje wykres
plot(punkty, wartosci);

end
