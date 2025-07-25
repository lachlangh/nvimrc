;; extends

((jsx_attribute
   ;; match the attribute name:
   (property_identifier)  @att_name (#eq? @att_name "className")
   ;; then dive into the quoted string and capture its contents:
   (string (string_fragment)  @class_value (#set!   @class_value conceal "…"))))
