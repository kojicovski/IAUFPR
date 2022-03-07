import cv2
img = cv2.imread('IAUFPR/computer_vision/exercise/images/home.jpg')
img = cv2.cvtColor(img, cv2.COLOR_BGR2HSV) #converte HSV

#cv2.imshow("0", img)
#cv2.waitKey(0)

(h, s, v) = cv2.split(img)

img_mg = cv2.merge((h * 2, s * 2, v))
cv2.imshow("0", cv2.hconcat([img, img_mg]))
cv2.waitKey(0)