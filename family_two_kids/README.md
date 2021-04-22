Curso de Especialização de Inteligência Artificial Aplicada

Setor de Educação Profissional e Tecnológica - SEPT

Universidade Federal do Paraná - UFPR

---

**IAA003 - Linguagem de Programação Aplicada**

# Exercício de implementação de algoritmo de probabilidade condicional

Pense no seguinte, uma família com dois filhos (desconhecidos).

Temos que:

1. É igualmente possível que cada criança seja menino ou menina
2. O gênero da segunda criança é independente do gênero da primeira, então o evento “nenhuma menina” tem a probabilidade de 1/4, o evento “uma menina, um menino” tem a probabilidade de 1/2 e o evento “duas meninas” tem a probabilidade de 1/4.

Agora, podemos perguntar: qual a probabilidade de o evento “as duas crianças são meninas” (B) ser condicionado pelo evento “a criança mais velha é uma menina” (G)?

Utilizando a probabilidade condicional, temos:

> P (B | G) = P (B, G) / P (G) =P (B) / P (G) = 1/2
> P (B | G) =  (1/4) / (1/2) = 1/2

Para que P(B) aconteça, necessariamente P(G) precisa também ocorrer: P(B/G) / P(G). 

Uma vez que o evento B e G (“ambas as crianças são meninas e a criança mais velha é uma menina”) é apenas o evento B. (Já sabendo que as duas crianças são meninas, é obrigatoriamente verdade que a criança mais velha seja menina.) Esse resultado talvez corresponda a sua intuição.

Agora, ser perguntarmos sobre a probabilidade do evento “as duas crianças são meninas” ser condicional ao evento “ao menos uma das crianças é menina” (L). 

Os eventos B e L (“as duas crianças são meninas e ao menos uma delas é uma menina”) é apenas o evento B. 

Assim, temos:
> Solução = {FF, FM, MF}
> P (B | L) = P (B, L) / P (L) = P (B) / P (L) = 1/3
> P (B | L) = (1 / 3) /  (2 / 3 ) = 1 / 3

Observando a solução, é possível identificar que a probabilidade de ser um menino e uma menina é duas vezes maior (1/3 * 1/3) que de ser duas meinas (1/3).

Isso tudo pode ser observado através do script [family_two_kids.py](./family_two_kids.py)
