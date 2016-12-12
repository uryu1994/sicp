(load "./2_71")

(print set5-huffman-tree)
;;         {ABCDE}(31)
;;           /     \
;;     {ABCD}(15)  E(16)
;;      /     \
;;  {ABC}(7)  D(8)
;;    /    \
;; {AB}(3) C(4)
;;  /  \
;;A(1) B(2)
;; n = 5の場合 最高頻度はE
;;             最低頻度はA

(print set10-huffman-tree)
;;n = 10も同様に考えると
;; 最高頻度はJ
;; 最低頻度はA

;;よって最低頻度は\theta(1) * \theta(1) = \theta(1)で
;;　　　最高頻度は\theta(n) * \theta(n) = \theta(n^2)
