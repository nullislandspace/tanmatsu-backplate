# Export the finished backplate (both holes cut) and the camera mount as
# watertight OpenSCAD polyhedrons.
#
# Run from anywhere -- paths below resolve relative to this script:
#   freecadcmd scripts/export_backplate.py
#
# Writes scad/backplate.scad, scad/camera_mount.scad, the matching .3mf files
# and scad/export.log. Everything in scad/ is generated -- never hand-edit it.
#
# Why the specific repair sequence below:
#   OCC's triangulator meshes each face independently, leaving hairline gaps
#   along shared edges. Those render fine alone but fail CGAL/Manifold Nef
#   conversion, so any union()/difference() blows up.
#
#   removeDuplicatedPoints + removeDuplicatedFacets + harmonizeNormals, then
#   fillupHoles(10), closes them: solid=True, nonmanifold=False, selfint=0.
#
#   Do NOT add removeFoldsOnSurface, fixDeformations or fixCaps -- measured on
#   this model, they delete good facets and inject 162-221 self-intersections.
#
#   Face winding is FLIPPED on output (t0, t2, t1). FreeCAD hands out facets
#   wound counter-clockwise seen from outside; OpenSCAD's polyhedron() wants
#   them clockwise seen from outside. Emitting FreeCAD's order verbatim gives a
#   closed but inside-out solid: it looks fine on its own and even reports
#   Status: NoError, but its signed volume is negative, and every difference()
#   against it explodes into big stray triangles. Check with a signed-volume
#   calculation on an exported STL -- it must come out positive.
#
import FreeCAD, MeshPart, os, traceback

try:
    HERE = os.path.dirname(os.path.abspath(__file__))
except NameError:                       # exec'd rather than run as a file
    HERE = os.path.join(os.getcwd(), "scripts")
ROOT = os.path.dirname(HERE)

SRC = os.path.join(ROOT, "Tanmatsu_3D-printed-with-camera-mount.FCStd")
OUT = os.path.join(ROOT, "scad")
DEFLECTION = 0.05
ANGULAR = 0.35

# Cut001 is the real final backplate: its base already had the camera lens
# hole, and it cuts the expansion connector hole on top. Despite the label.
TARGETS = [("Cut001", "backplate"), ("Group003", "camera_mount")]

os.makedirs(OUT, exist_ok=True)
log = open(os.path.join(OUT, "export.log"), "w")
doc = FreeCAD.openDocument(SRC)

for name, module in TARGETS:
    o = doc.getObject(name)
    if o is None:
        log.write("MISSING %s\n" % name); continue
    try:
        m = MeshPart.meshFromShape(Shape=o.Shape, LinearDeflection=DEFLECTION,
                                   AngularDeflection=ANGULAR, Relative=False)
        m.removeDuplicatedPoints()
        m.removeDuplicatedFacets()
        m.harmonizeNormals()
        m.fillupHoles(10)

        if not m.isSolid() or m.hasNonManifolds():
            log.write("WARN %s is not watertight after repair -- booleans will fail\n" % module)

        verts, facets = m.Topology
        with open(os.path.join(OUT, module + ".scad"), "w") as f:
            f.write("// Generated from %s\n" % os.path.basename(SRC))
            f.write("// Source object: %s (%r)\n" % (o.Name, o.Label))
            f.write("// %d vertices, %d triangles, watertight=%s\n\n"
                    % (len(verts), len(facets), m.isSolid()))
            f.write("module %s() {\n  polyhedron(\n    points = [\n" % module)
            f.write(",\n".join("      [%.4f, %.4f, %.4f]" % (v[0], v[1], v[2]) for v in verts))
            f.write("\n    ],\n    faces = [\n")
            f.write(",\n".join("      [%d, %d, %d]" % (t[0], t[2], t[1]) for t in facets))
            f.write("\n    ],\n    convexity = 10);\n}\n")

        m.write(os.path.join(OUT, module + ".3mf"))   # for slicer / import() use

        bb = o.Shape.BoundBox
        log.write("%-4s %-22s -> %-18s tris=%-7d solid=%-5s vol=%9.1f bbox=%.1f x %.1f x %.1f mm\n"
                  % ("OK" if m.isSolid() else "WARN", o.Label, module,
                     len(facets), m.isSolid(), o.Shape.Volume,
                     bb.XLength, bb.YLength, bb.ZLength))
    except Exception:
        log.write("FAIL %s\n%s\n" % (name, traceback.format_exc()))
log.close()
