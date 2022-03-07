import cv2

# Ler a imagem com a funcao imread()
imagem = cv2.imread('IAUFPR/computer_vision/exercise/images/example1.png', cv2.IMREAD_UNCHANGED)

print('Largura: ', imagem.shape[1]) #largura da imagem

print('Altura: ', imagem.shape[0]) #altura da imagem

print('Canais de Cor: ', imagem.shape[2])

# Mostra a imagem 
cv2.imshow("0", imagem)
cv2.waitKey(0)

# rescalando imagem
small_img = cv2.resize(imagem.copy(), (0,0), fx=0.5, fy=0.5) 

print('Largura: ', small_img.shape[1]) #largura da imagem

print('Altura: ', small_img.shape[0]) #altura da imagem

cv2.imshow("1", small_img)
cv2.waitKey(0)