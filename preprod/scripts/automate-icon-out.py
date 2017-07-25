import bpy


resolutions = {20, 29, 40, 60, 76, 83.5}

for r in resolutions:
    
    for i in range(3):
    
        scene = bpy.context.scene
    
        scene.render.resolution_x = r
        scene.render.resolution_y = r
  
        scene.render.filepath = "//icons/" + str(r) + "@" + str(i + 1) + "x"
      
        scene.render.resolution_percentage = (i + 1) * 100
        bpy.ops.render.opengl( write_still=True ) 