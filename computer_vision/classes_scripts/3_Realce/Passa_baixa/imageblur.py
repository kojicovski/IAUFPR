# Adding noise to the image    

import cv2
import numpy as np

img = cv2.imread('classes_scripts/3_Realce/images/wiki_saltpeper.jpg',0)
im = np.zeros(img.shape, np.uint8) # do not use original image it overwrites the image

cv2.imshow("Original", img)
cv2.waitKey(0)

im = cv2.GaussianBlur(img,(3,3),0)
cv2.imshow("Gaussian 3x3*", im)
cv2.waitKey(0)

im = cv2.GaussianBlur(img,(5,5),0)
cv2.imshow("Gaussian 5x5", im)
cv2.waitKey(0)

im = cv2.medianBlur(img, 3)
cv2.imshow("Median 3x3", im)
cv2.waitKey(0)

im = cv2.medianBlur(img, 5)
cv2.imshow("Median 5x5", im)
cv2.waitKey(0)

im = cv2.blur(img,(3,3) )
cv2.imshow("Blur 3x3", im)
cv2.waitKey(0)

im = cv2.blur(img, (5,5) )
cv2.imshow("Blur 5x5", im)
cv2.waitKey(0)

