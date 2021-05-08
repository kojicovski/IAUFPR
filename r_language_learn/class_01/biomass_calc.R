# Calcule a biomassa estimada por cada modelo para uma árvore com dap de 15cm e 
# altura de 12m. Coloque a estimativa do modelo alométrico em um objeto chamado 
# biomassa1 e a estimativa do segundo modelo no objeto biomassa2.

h = 12
d = 15

biomass_1 <- exp(-1.7953) * d^2.2974

lnb <- -2.6464 + 1.9960*log(d,exp(1)) + 0.7558*log(h,exp(1))
biomass_2 <- exp(lnb)

paste("Com exp(-1.7953) * d^2.2974: ",round(biomass_1,2))
paste("Com -2.6464 + 1.9960 ln(d) + 0.7558 ln(h):", round(biomass_2,2))
