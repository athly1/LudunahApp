// Spacing.swift - spacing and corner radius values.
//
// Contains:
// - Spacing values: xs, sm, md, lg, xl (for example 4, 8, 16, 24, 32).
// - Corner radius values: sm, md, lg.
// - Use these for padding, stack spacing, and rounded corners.
//
// Used by: all views and components.
// Spacing.swift - All layout design tokens.
// Contains standard padding, spacing, and element dimensions.

import CoreGraphics

struct Spacing {
    // الهوامش والمسافات الداخلية (Paddings & Spacings)
    static let space4: CGFloat = 4      // بين الأيقونة ونصها
    static let space8: CGFloat = 8      // بين العنوان والوصف، أو بين الأزرار الصغيرة
    static let space12: CGFloat = 12    // داخل البطاقات الصغيرة، أو بين عناصر القائمة
    static let space16: CGFloat = 16    // المسافة المعيارية للبطاقات وهوامش المحتوى الداخلي
    static let space24: CGFloat = 24    // الفراغ بين الأقسام الرئيسية في الصفحة
    static let space32: CGFloat = 30    // الفراغ أسفل العناصر الكبيرة أو الأزرار الأساسية
    
    // أبعاد العناصر الثابتة (Layout Dimensions)
    static let pageMargin: CGFloat = 24      // الهامش الجانبي الافتراضي للصفحات
    static let controlHeight: CGFloat = 50   // الارتفاع الافتراضي للأزرار وحقول الإدخال الأساسية
    static let ButtonWidth: CGFloat = 324    // العرض اللازرار
    static let ButtonTextPaddingHeight: CGFloat = 34  // الطول اللازرار
    static let controlHeightSm: CGFloat = 44 // الارتفاع للأزرار وعناصر التحكم الثانوية
    static let chipHeight: CGFloat = 32      // الارتفاع الافتراضي للبطاقات الصغيرة (Chips/Badges)
    static let headerTitleOffset: CGFloat = 62 // الإزاحة المخصصة لعناوين الهيدر الكبيرة
}
