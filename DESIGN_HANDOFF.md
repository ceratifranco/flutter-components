# Design Handoff — Analytics Dashboard

**Version:** 1.2  
**Fecha:** Abril 2026  
**Estado:** ✅ Implementado v2 — accesible, responsive, con data layer desacoplada  
**Figma:** [pOFa94IErywvDwd8fzPKqs](https://www.figma.com/design/pOFa94IErywvDwd8fzPKqs/Figma-testing)  
**Plataforma:** Flutter (iOS · Android · Web)

---

## Índice

1. [Overview](#1-overview)
2. [Design Tokens](#2-design-tokens)
3. [Pantallas](#3-pantallas)
4. [Componentes](#4-componentes)
5. [Interacciones y Animaciones](#5-interacciones-y-animaciones)
6. [Accesibilidad](#6-accesibilidad)
7. [Estado de assets](#7-estado-de-assets)
8. [Checklist de handoff](#8-checklist-de-handoff)

---

## 1. Overview

### Descripción
App de analytics financiero que permite visualizar la distribución del presupuesto anual (donut chart) y la evolución de revenue mensual (bar chart), con detalle por segmento al hacer tap en cada elemento del gráfico.

### Objetivo del usuario
> "Como CFO, quiero ver en un vistazo cómo está distribuido el presupuesto y la evolución de revenue, y poder profundizar en cualquier categoría con un tap."

### Criterios de éxito
- El usuario puede llegar al detalle de cualquier segmento en ≤ 2 taps
- Los datos numéricos son legibles sin zoom en pantallas de 375pt de ancho
- Las animaciones no superan los 200ms para no sentirse lentas

---

## 2. Design Tokens

### Colores

| Token | Hex | Uso |
|---|---|---|
| `kNavy` | `#1B2B4B` | Títulos, avatar, botón CTA |
| `kBlue` | `#2563EB` | Nav activo, barra activa, Revenue |
| `kPurple` | `#7C3AED` | Operations |
| `kGreen` | `#059669` | Marketing, crecimiento positivo |
| `kAmber` | `#F59E0B` | R&D, valores restantes |
| `kRed` | `#EF4444` | Other, crecimiento negativo |
| `background` | `#F0F3F9` | Fondo de scaffold |
| `surface` | `#FFFFFF` | Cards, header, bottom nav, sheets |
| `border` | `#F1F5F9` | Divisores, borde del bottom nav |
| `textPrimary` | `#111827` | Texto principal en cards |
| `textSecondary` | `#ADB5BD` | Subtítulos, hints, labels de ejes |
| `textDark` | `#1E293B` | Títulos en sheets |

### Tipografía

| Uso | Size | Weight | Letter Spacing |
|---|---|---|---|
| Título pantalla (Analytics) | 24pt | w800 | -0.8 |
| Subtítulo pantalla | 12pt | w400 | +0.1 |
| Título card | 16pt | w700 | -0.3 |
| Subtítulo card | 12pt | w400 | +0.1 |
| Monto principal (sheet) | 40pt | w800 | -1.5 |
| Chip label | 12pt | w600 | +0.2 |
| Stat value | 18pt | w700 | -0.3 |
| Stat label | 11pt | w400 | +0.1 |
| Section label (sheet) | 14pt | w700 | -0.2 |
| Hint text | 11pt | w400 | +0.1 |
| Nav item activo | 13pt | w700 | -0.1 |
| Nav item inactivo | 13pt | w400 | 0 |
| Legend label | 12pt | w500/w700 | 0 |
| Legend value | 11pt | w400 | 0 |
| Eje Y del gráfico | 10pt | w400 | 0 |
| Mes activo (eje X) | 11pt | w700 | 0 |

> **Fuente:** Sistema (San Francisco en iOS, Roboto en Android). No se usa fuente custom.

### Espaciado

| Token | Valor | Uso |
|---|---|---|
| `pagePadding` | 16pt | Padding horizontal del scroll |
| `cardPadding` | 20pt | Padding interno de cards |
| `cardGap` | 16pt | Separación entre cards |
| `sheetPadding` | 24pt | Padding horizontal en sheets |
| `sectionGap` | 20–24pt | Separación entre secciones en sheet |
| `statGap` | 3pt | Entre valor y label en stat |
| `legendItemGap` | 9pt | Separación vertical entre ítems de leyenda |

### Border Radius

| Elemento | Radio |
|---|---|
| Cards | 20pt |
| Bottom Sheet | 28pt (top) |
| Chips / Pills | 20pt (full pill) |
| CTA Button | 14pt |
| Barras del gráfico | 6pt (top) |
| Mini barras | 5pt (top) |
| Indicador nav activo | 2pt |
| Progress track | 3.5pt |

### Sombras

**Card:**
```
Layer 1: color #1B2B4B @ 5% opacity, blur 20, offset (0, 4)
Layer 2: color #1B2B4B @ 3% opacity, blur 6, offset (0, 1)
```

**Header:**
```
color #1B2B4B @ 4% opacity, blur 12, offset (0, 2)
```

**Progress thumb:**
```
color [segment color] @ 25% opacity, blur 6, offset (0, 2)
```

---

## 3. Pantallas

### Screen 1 — Dashboard

```
┌────────────────────────────┐
│  StatusBar (dark icons)    │
├────────────────────────────┤
│  Header (white + shadow)   │
│  "Analytics"               │
│  "Q2 2025 — Financial..."  │   [FC]
├────────────────────────────┤
│  ↕ ScrollView (bouncing)  │
│                            │
│  ┌──────────────────────┐  │
│  │  Budget Allocation   │  │
│  │  Donut + Legend      │  │
│  └──────────────────────┘  │
│                            │
│  ┌──────────────────────┐  │
│  │  Monthly Revenue     │  │
│  │  Bar Chart           │  │
│  └──────────────────────┘  │
│                            │
├────────────────────────────┤
│  Bottom Nav (white)        │
│  Analytics · Reports · Settings
└────────────────────────────┘
```

**Padding scroll inferior:** `safe_area_bottom + 88pt` (evita que el último card quede bajo el nav)

---

### Screen 2 — Pie Detail Sheet

Disparado al tocar cualquier segmento del donut o ítem de la leyenda. Se abre como `ModalBottomSheet`.

```
┌─────────────────────────────┐
│  ▬  (handle, centrado)      │
│                             │
│  [Revenue]   ← chip pill    │
│                             │
│  $2.4M                      │
│  Allocated — FY 2025 · 30%  │
│  of total budget            │
│  ─────────────────────────  │
│  +12.4%   $1.8M   $0.6M    │
│  vs LY    YTD     Remaining │
│  ─────────────────────────  │
│  Budget Utilization    75%  │
│  [====●───────────────────] │
│                             │
│  Monthly Breakdown          │
│  [J][F][M][A■][M][J]        │
│                             │
│  [View Full Revenue Report→]│
└─────────────────────────────┘
```

**Padding inferior:** `safe_area_bottom + 20pt`

---

### Screen 3 — Bar Detail Sheet

Disparado al tocar cualquier barra del gráfico de revenue.

```
┌─────────────────────────────┐
│  ▬  (handle)                │
│                             │
│  [Apr 2025]  ← chip pill    │
│                             │
│  $90K                       │
│  [↑ +9.8% vs previous month]│
│  ─────────────────────────  │
│  24        $3.75K   2.1%   │
│  New Clients  Avg Deal  Churn│
│  ─────────────────────────  │
│  Revenue Sources            │
│  ● Enterprise  55%          │
│  [==========●─────────────] │
│  ● SMB         30%          │
│  [======●─────────────────] │
│  ● Self-serve  15%          │
│  [===●────────────────────] │
│                             │
│  [View Full Apr Report →]   │
└─────────────────────────────┘
```

---

## 4. Componentes

### 4.1 Card

| Prop | Valor |
|---|---|
| Background | `#FFFFFF` |
| Border radius | `20pt` |
| Padding | `20pt top/left/right · 18pt bottom` |
| Shadow | Ver sección tokens |

**Estados:** Solo estado default. No hay hover/focus en mobile.

---

### 4.2 Donut Chart Card

| Prop | Valor |
|---|---|
| Tamaño del donut | `160 × 160pt` |
| Radio centro (vacío) | `46pt` |
| Grosor de sección inactiva | `54pt` |
| Grosor de sección activa (tocada) | `62pt` |
| Gap entre secciones | `2.5pt` |
| Centro — estado default | `$8.0M / Total` |
| Centro — estado tocado | `XX% / [Label]` en color del segmento |

**Leyenda:**
- Dot: `8pt` círculo sólido en color del segmento
- Label (línea 1): `12pt w500`, color `#1E293B`; activo: `w700`
- Label (línea 2): valor en dólares, `11pt`, color `#ADB5BD`
- Fondo activo: `[color segmento] @ 8% opacity`, `borderRadius: 8pt`
- Margin entre ítems: `9pt`

---

### 4.3 Bar Chart Card

| Prop | Valor |
|---|---|
| Altura del chart | `176pt` |
| Max Y | `115` |
| Ancho de barra | `22pt` |
| Border radius barra | `6pt top` |
| Color barra inactiva | `#DDE6FB` |
| Color barra activa | `kBlue (#2563EB)` |
| Grid lines | Horizontal, cada 50 unidades, color `#F1F5F9` |
| Eje Y labels | `0, 50, 100` · `10pt` · `#CBD5E1` |
| Eje X labels | Mes abreviado · `11pt` · activo: `kBlue w700` |

**Tooltip:**
- Background: `kNavy (#1B2B4B)`
- Border radius: `10pt`
- Padding: `12pt horizontal · 7pt vertical`
- Texto: `$XXK` · `12pt w700` · blanco

---

### 4.4 Progress Bar (con thumb)

| Prop | Valor |
|---|---|
| Alto total del widget | `24pt` |
| Alto del track | `7pt` |
| Border radius track | `3.5pt` |
| Color track (fondo) | `#F1F5F9` |
| Color fill | Color del segmento |
| Diámetro del thumb | `18pt` |
| Color thumb | `#FFFFFF` (blanco) |
| Borde thumb | `2.5pt solid [color segmento]` |
| Sombra thumb | `[color] @ 25%`, blur `6`, offset `(0,2)` |

---

### 4.5 Chip / Pill

| Prop | Valor |
|---|---|
| Padding | `12pt horizontal · 6pt vertical` |
| Border radius | `20pt` |
| Background | `[color] @ 10% opacity` |
| Texto | `12pt w600`, color sólido del segmento |

---

### 4.6 CTA Button

| Prop | Valor |
|---|---|
| Background | `kNavy (#1B2B4B)` |
| Color texto | `#FFFFFF` |
| Padding vertical | `17pt` |
| Border radius | `14pt` |
| Elevation | `0` |
| Fuente | `15pt w600`, letterSpacing `0.1` |
| Icono | `Icons.arrow_forward_rounded`, `18pt`, trailing |

---

### 4.7 Bottom Navigation

| Prop | Valor |
|---|---|
| Alto (sin safe area) | `58pt` |
| Background | `#FFFFFF` |
| Border top | `1pt solid #F1F5F9` |
| Ítems | Analytics · Reports · Settings |
| Texto activo | `13pt w700 kBlue`, letterSpacing `-0.1` |
| Texto inactivo | `13pt w400 #ADB5BD` |
| Indicador activo | rect `20×2.5pt`, `kBlue`, borderRadius `2pt` |
| Animación indicador | `200ms easeOut` |

---

### 4.8 Avatar

| Prop | Valor |
|---|---|
| Tamaño | `38×38pt`, circular |
| Background | `kNavy (#1B2B4B)` |
| Texto | `"FC"` · `12pt w700` · blanco · letterSpacing `0.5` |

---

### 4.9 Handle (Sheet)

| Prop | Valor |
|---|---|
| Tamaño | `36×4pt` |
| Color | `#E2E8F0` |
| Border radius | `2pt` |
| Margin | `14pt top · 22pt bottom` |

---

### 4.10 Mini Bar Chart (en Pie Detail)

| Prop | Valor |
|---|---|
| Altura máxima de barra | `60pt` |
| Border radius | `5pt top` |
| Padding horizontal entre barras | `4pt cada lado` |
| Color barra inactiva | `[color segmento] @ 15% opacity` |
| Color barra activa (más alto) | Color sólido del segmento |
| Label mes inactivo | `10pt w400 #CBD5E1` |
| Label mes activo | `10pt w700 [color segmento]` |

---

## 5. Interacciones y Animaciones

### Tap en segmento del donut

| Paso | Comportamiento |
|---|---|
| Touch down | Sección se expande a `radius: 62`, las demás se mantienen en `52` |
| Touch up | Se abre `PieDetailSheet` como ModalBottomSheet |
| Touch cancel / fuera | Sección vuelve a `radius: 52`, centro vuelve a `$8.0M` |
| Centro del donut | Cambia a `XX% / [Label]` con `AnimatedSwitcher 180ms` |

### Tap en barra del gráfico

| Paso | Comportamiento |
|---|---|
| Touch down | Barra cambia a `kBlue`, eje X label cambia a `kBlue w700`, tooltip aparece |
| Touch up | Se abre `BarDetailSheet` como ModalBottomSheet |
| Touch cancel / fuera | Barra vuelve a `#DDE6FB`, label vuelve a `#ADB5BD w400` |

### ModalBottomSheet

| Prop | Valor |
|---|---|
| `isScrollControlled` | `true` |
| `backgroundColor` | `transparent` |
| `borderRadius` | `28pt top` |
| Dismiss | Swipe down o tap en backdrop |

### Bottom Nav

| Prop | Valor |
|---|---|
| Cambio de tab | Tap en cualquier ítem |
| Animación indicador | `AnimatedContainer 200ms easeOut`, ancho `0→20pt` |

### Leyenda del donut (tap)

- Tap sobre un ítem de la leyenda selecciona ese segmento (highlight en donut + fondo en leyenda) y abre el sheet
- Segundo tap sobre el mismo ítem lo deselecciona

---

## 6. Accesibilidad

| Ítem | Estado |
|---|---|
| Contraste texto/fondo en cards | ✅ `#111827` sobre `#FFF` → 16.1:1 |
| Contraste hint text | ⚠️ `#CBD5E1` sobre `#FFF` → 2.8:1 (decorativo, no crítico) |
| Contraste texto activo nav | ✅ `kBlue` sobre `#FFF` → 4.6:1 |
| Touch targets mínimos | ✅ Barras: 22pt ancho + hit area extendido; Nav items: 100pt |
| Feedback táctil | ✅ `HapticFeedback.selectionClick()` en hover de chart, `lightImpact()` en taps |
| Screen reader (Semantics) | ✅ Wrappers en charts, legend (button), sheets (header), nav (button + selected), avatar |

---

## 7. Estado de assets

| Asset | Formato | Estado |
|---|---|---|
| Íconos UI | `Icons.*` (Material) | ✅ Incluido en Flutter |
| Fuentes custom | Ninguna (sistema) | ✅ Sin acción |
| Imágenes | Ninguna | ✅ Sin acción |
| Colores | Constantes Dart en `dummy_data.dart` | ✅ Definidos |
| Datos | `MockAnalyticsService` (delay 800ms) | ✅ Arquitectura swappable — `HttpAnalyticsService` listo para conectar a API real |

---

## 8. Checklist de handoff

### Diseño
- [x] Todas las pantallas completas y revisadas (Dashboard, Pie Detail, Bar Detail)
- [x] Estados de componentes documentados (default, activo, inactivo)
- [x] Especificaciones de tipografía
- [x] Especificaciones de colores con hex
- [x] Sombras y elevaciones definidas
- [x] Border radius especificados
- [x] Animaciones con duraciones y curvas
- [x] Interacciones especificadas (tap, dismiss)
- [x] Copy y labels finalizados
- [ ] Dark mode (fuera de scope v1)
- [ ] Variantes responsive (tablet) — pendiente v2

### Implementación
- [x] `AnalyticsProvider` (ChangeNotifier) para estado global
- [x] `MultiProvider` en `main.dart`
- [x] `DashboardScreen` refactorizado a `StatelessWidget`
- [x] Widgets extraídos: `_DashboardHeader`, `_Avatar`, `_BottomNav`, `_NavItem`
- [x] `const` constructors en todos los widgets que lo permiten
- [x] `flutter analyze` sin warnings
- [x] `dart fix` sin sugerencias pendientes

### Implementación v2 completada
- [x] `Semantics` en gráficos (chart container + legend items con `button: true` + sheets con `header: true` + nav con `selected`)
- [x] `HapticFeedback` (`selectionClick` en cambio de hover sobre chart, `lightImpact` en tap de bar/pie/CTA/legend)
- [x] Data layer desacoplada: `AnalyticsService` (abstract) → `MockAnalyticsService` (delay 800ms) + `HttpAnalyticsService` (stub)
- [x] Provider con estados `isLoading`, `error`, `data` + `load()` / `refresh()`
- [x] `CardSkeleton` (shimmer custom con `AnimationController`) → `DonutCardSkeleton`, `BarCardSkeleton`
- [x] `ErrorCard` con icono `cloud_off`, mensaje y botón Retry
- [x] Layout responsive: mobile (<600pt) → Column, tablet+ (≥600pt) → Row 2-col, desktop (≥1024pt) → centrado max-width 1200pt
- [x] Padding escalado (16/24/32 horizontal · 20/32/48 header)

### Backlog futuro (v3+)
- [ ] Conectar `HttpAnalyticsService` a backend real (URL + parsing JSON)
- [ ] Pull-to-refresh en mobile
- [ ] Pantallas Reports y Settings (placeholders actualmente)
- [ ] Dark mode con theme switcher
- [ ] Side nav rail para desktop (>1280pt) en lugar de bottom nav
- [ ] Tests: widget tests para charts, sheets y provider; integration test del flow completo
- [ ] i18n (currently English-only)
- [ ] Caching local con `shared_preferences` o Hive para offline-first

---

## 9. Componentes de estado (v2)

### 9.1 CardSkeleton

| Variante | Uso |
|---|---|
| `DonutCardSkeleton` | Placeholder durante load del Budget Allocation card |
| `BarCardSkeleton` | Placeholder durante load del Monthly Revenue card |

| Prop interno | Valor |
|---|---|
| Animación shimmer | `AnimationController` 1500ms loop |
| Gradient | 3 stops: `#EFF2F7 → #F8FAFC → #EFF2F7`, slide horizontal de `-1.5` a `+1.5` |
| Border radius interno | `8pt` |
| Wrapper | `cardWrapper()` (mismo radio + sombra que estado loaded → cero layout shift) |

### 9.2 ErrorCard

| Prop | Valor |
|---|---|
| Icon container | `56×56pt`, circular, `kRed @ 10%` |
| Icon | `Icons.cloud_off_rounded`, `28pt`, `kRed` |
| Título | `"Something went wrong"` · `16pt w700 #1E293B` |
| Mensaje | `12pt #ADB5BD`, line-height `1.5`, centrado |
| Retry button | `FilledButton.icon` (refresh icon + label), `kNavy` background, radius `12pt` |

---

## 10. Breakpoints responsive (v2)

| Breakpoint | Rango | Layout |
|---|---|---|
| Mobile | `< 600pt` | Column vertical (donut arriba, bar abajo) |
| Tablet | `600pt – 1024pt` | Row 2-col (donut + bar lado a lado, gap 16pt) |
| Desktop | `≥ 1024pt` | Row 2-col centrada, max-width `1200pt` |

| Prop | Mobile | Tablet | Desktop |
|---|---|---|---|
| Page horizontal padding | 16pt | 24pt | 32pt |
| Header horizontal padding | 20pt | 32pt | 48pt |
| Cards layout | Column | Row | Row centrada |
| Bottom nav | Visible | Visible | Visible |

Helpers en `lib/utils/breakpoints.dart`: `isMobile(context)`, `isTablet(context)`, `isDesktop(context)`, `scaledHorizontalPadding(context)`, `scaledHeaderPadding(context)`.

---

## 11. Estructura de proyecto (v2)

```
lib/
├── main.dart                          # MultiProvider + MaterialApp
├── data/
│   └── dummy_data.dart                # Color tokens + sample data
├── models/
│   └── dashboard_data.dart            # DashboardData wrapper
├── services/
│   └── analytics_service.dart         # AnalyticsService + Mock + Http stub
├── providers/
│   └── analytics_provider.dart        # ChangeNotifier (load/refresh + selección)
├── utils/
│   └── breakpoints.dart               # Responsive helpers
├── screens/
│   └── dashboard_screen.dart          # Layout responsive + loading/error switch
└── widgets/
    ├── ui_helpers.dart                # cardWrapper, sheet*, progress bar, CTA
    ├── donut_chart_card.dart          # Donut + legend (Semantics + haptic)
    ├── bar_chart_card.dart            # Bar chart (Semantics + haptic)
    ├── pie_detail_sheet.dart          # Detail sheet del donut
    ├── bar_detail_sheet.dart          # Detail sheet del bar chart
    ├── card_skeleton.dart             # Skeletons animados (loading state)
    └── error_card.dart                # Error state con Retry
```

---

*Generado con Claude Code · Analytics Dashboard v1.2*
