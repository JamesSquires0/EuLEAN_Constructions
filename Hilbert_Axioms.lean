namespace Geometry

-- Primitive types
axiom Point : Type
axiom Line  : Type
axiom Plane : Type

-- Primitive relations
axiom PointLiesOnLine  : Point → Line  → Prop
axiom PointLiesOnPlane : Point → Plane → Prop
axiom LineLiesOnPlane  : Line  → Plane → Prop
axiom Between : Point → Point → Point → Prop

-- Predicates
def Collinear (A B C : Point) : Prop :=
  ∃ ℓ : Line, PointLiesOnLine A ℓ ∧ PointLiesOnLine B ℓ ∧ PointLiesOnLine C ℓ

def Coplanar (A B C : Point) : Prop :=
  ∃ π : Plane, PointLiesOnPlane A π ∧ PointLiesOnPlane B π ∧ PointLiesOnPlane C π

/-
HILBERT: INCIDENCE (lines)
I1 Existence + uniqueness of a line through two distinct points
-/
axiom twoPointsMakeLine :
  ∀ {A B : Point}, A ≠ B →
    ∃ ℓ : Line,
      PointLiesOnLine A ℓ ∧ PointLiesOnLine B ℓ ∧
      (∀ ℓ' : Line, PointLiesOnLine A ℓ' → PointLiesOnLine B ℓ' → ℓ' = ℓ)

-- I2 Every line has at least two distinct points
axiom lineHasTwoPoints :
  ∀ ℓ : Line, ∃ (A B : Point), A ≠ B ∧
    PointLiesOnLine A ℓ ∧ PointLiesOnLine B ℓ

-- I3 There exist three non-collinear points
axiom threePointsNotCollinear :
  ∃ (A B C : Point), ¬ Collinear A B C

/-
HILBERT: INCIDENCE (planes)
I4 Through any three non-collinear points, there is a unique plane
-/
axiom threePointsCoplanar_unique :
  ∀ {A B C : Point}, ¬ Collinear A B C →
    ∃ π : Plane,
      (PointLiesOnPlane A π ∧ PointLiesOnPlane B π ∧ PointLiesOnPlane C π) ∧
      (∀ π' : Plane,
         PointLiesOnPlane A π' → PointLiesOnPlane B π' → PointLiesOnPlane C π' → π' = π)

/-
I5 Every plane has three non-collinear points
-/
axiom threeNonCollinearPoints_atMostOnePlane :
  ∀ π : Plane, ∃ (A B C : Point), PointLiesOnPlane A π ∧ PointLiesOnPlane B π ∧ PointLiesOnPlane C π ∧
    ¬∃ ℓ : Line, (PointLiesOnLine A ℓ ∧ PointLiesOnLine B ℓ ∧ PointLiesOnLine C ℓ)

/-
I6 Two points on a line and also on a plane imply the line is on the plane
-/
axiom twoPointsColinearCoplanar_LineInPlane :
  ∀ (A B : Point), ∀ ℓ : Line, ∀ π : Plane,
   ((PointLiesOnLine A ℓ ∧ PointLiesOnLine B ℓ ∧ PointLiesOnPlane A π ∧ PointLiesOnPlane B π) →
    LineLiesOnPlane ℓ π)

/-
I7 Two distinct planes share a point iff they share a line
-/
axiom distinctPlanesSharePoint_ShareLine :
  ∀ (π ρ : Plane), (π ≠ ρ ∧ ∃ P : Point, (PointLiesOnPlane P π ∧ PointLiesOnPlane P ρ) →
   ∃ ℓ : Line, ∀ Q : Point, (PointLiesOnLine Q ℓ ↔ PointLiesOnPlane Q π ∧ PointLiesOnPlane Q ρ))

/-
I8 There exist four non-coplanar points
-/
axiom existenceFourNonCoplanarPoints :
  ∃ (A B C D : Point), ¬∃ π : Plane,
   (PointLiesOnPlane A π ∧ PointLiesOnPlane B π ∧ PointLiesOnPlane C π ∧ PointLiesOnPlane D π)

/-
HILBERT: BETWEENNESS (ORDER)
B1 If B between A and C, then B between C and A. Also, there exists a line on which A, B, C lie
-/
axiom symmBetweeness_andColinear :
  ∀ (A B C : Point), (Between A B C →
   (Between C B A ∧ A ≠ B ∧ B ≠ C ∧ A ≠ C ∧
    ∃ ℓ : Line, (PointLiesOnLine A ℓ ∧ PointLiesOnLine B ℓ ∧ PointLiesOnLine C ℓ)))

/-
B2 A and C share line imply C between some point B and A
-/
axiom twoPointsShareLine_ExistThirdPoint :
  ∀ (A C : Point), (A ≠ C → ∃ B : Point, (Between A C B))

/-
B3 Three points share line implies only one middle point (Trichotomy)
-/
axiom threePointsOneMiddle :
  ∀ (A B C : Point),
    Collinear A B C ∧ A ≠ B ∧ B ≠ C ∧ A ≠ C →
      ((Between A B C ∨ Between B C A ∨ Between C A B) ∧
        ¬(Between A B C ∧ Between B C A) ∧
        ¬(Between A B C ∧ Between C A B) ∧
        ¬(Between B C A ∧ Between C A B))

/-
B4 Pasch's Axiom: Three points, not all collinear, and a line not containing any of these points imply
the line passing through a segment produced by two of the points, must pass through a line produced by two of the other points
-/
axiom Pasch_Axiom :
  ∀ (A B C : Point), ∀ ℓ : Line, ((¬Collinear A B C) ∧ ℓ )
/-
Glue axioms to connect the primitives (standard, minimal, and very handy):

II.2 If two points on a line lie in a plane, then the whole line lies in the plane.
-/
axiom lineInPlane_of_twoPointsInPlane :
  ∀ {A B : Point} {ℓ : Line} {π : Plane},
    PointLiesOnLine A ℓ → PointLiesOnLine B ℓ →
    PointLiesOnPlane A π → PointLiesOnPlane B π →
    LineLiesOnPlane ℓ π

axiom pointInPlane_of_pointOnLine_and_lineInPlane :
  ∀ {P : Point} {ℓ : Line} {π : Plane},
    PointLiesOnLine P ℓ → LineLiesOnPlane ℓ π → PointLiesOnPlane P π

/-
II.3 A plane intersection must contain a line
-/

def LineAB : Line

end Geometry
