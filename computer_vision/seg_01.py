import cv2
import numpy as np

img_real = cv2.imread('classes_scripts/6_Exercicio/images/Convolvulus_arvensis_07.jpg')
img = cv2.cvtColor(img_real, cv2.COLOR_RGB2GRAY)

new_img = np.zeros_like(img_real)

cv2.imshow("1", img_real)
# cv2.waitKey(0)

suave = cv2.GaussianBlur(img, (5,33), 0) # aplica blur
# (T, bin) = cv2.threshold(suave, 105, 255, cv2.THRESH_BINARY)
# (T, binI) = cv2.threshold(suave, 105, 255,
# cv2.THRESH_BINARY_INV)

thresh = cv2.adaptiveThreshold(suave, 255,
	cv2.ADAPTIVE_THRESH_MEAN_C, cv2.THRESH_BINARY, 131, 4)

# cv2.imshow("Mean Adaptive Thresholding", thresh)

contours, heirarchy = cv2.findContours(thresh, cv2.RETR_TREE, cv2.CHAIN_APPROX_SIMPLE)
cv2.drawContours(new_img, contours, -1, (255,255,255), -1)



# resultado = np.vstack([
# np.hstack([suave, bin]),
# np.hstack([binI, cv2.bitwise_and(img, img, mask = binI)])
# ])

cv2.imshow("Binarizacao da imagem", new_img)
cv2.waitKey(0)