import cv2
import numpy as np
 
img = cv2.imread('images/ktGvQ.png',0) #T-Rex_1_grande.jpg',0)
 #Celtis_occidentalis_leaf.png',0) #leaf2.jpg',0) # Ginkgo_biloba_scanned_leaf.jpg',0)

size = np.size(img)
skel = np.zeros(img.shape,np.uint8)
 
ret,img = cv2.threshold(img,157,255,0)
element = cv2.getStructuringElement(cv2.MORPH_CROSS,(3,3))
done = False
cv2.imshow("Imagem original", img)
cv2.waitKey(0)

while( not done):
    eroded = cv2.erode(img, element)
    temp = cv2.dilate(eroded,element)
    temp = cv2.subtract(img, temp)
    skel = cv2.bitwise_or(skel,temp)
    img = eroded.copy() #(img, element)
    
    _, maxval, _, _ = cv2.minMaxLoc(img)
    done = (maxval == 0)
 
cv2.imshow("skel",skel)
cv2.waitKey(0)
cv2.destroyAllWindows()
