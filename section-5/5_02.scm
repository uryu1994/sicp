(controller
 (assign p (const 1))
 (assign c (const 1))
 test-c
 (test (op >) (reg c) (reg n))
 (branch (label factorial-done))
 (assign np (op *) (reg c) (reg p))
 (assign nc (op +) (reg c) (const 1))
 (assign p (reg np))
 (assign c (req nc))
 (goto (label factorial-done))
 factorial-done)

;; (自明ではないが) pとcに直接assignする場合もありか?
(controller
 (assign p (const 1))
 (assign c (const 1))
 test-c
 (test (op >) (reg c) (reg n))
 (branch (label factorial-done))
 (assign p (op *) (reg c) (reg p))
 (assign c (op +) (reg c) (const 1))
 (goto (label factorial-done))
 factorial-done)
