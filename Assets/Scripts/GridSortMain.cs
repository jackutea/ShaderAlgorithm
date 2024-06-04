using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace ShaderAlgorithm {

    [ExecuteInEditMode]
    public class GridSortMain : MonoBehaviour {

        void Update() {

            Camera cam = Camera.main;
            float fov = cam.fieldOfView;

            // TopLeft to BottomRight
            float gap = 1.5f;
            Vector3 topLeft = cam.ViewportToWorldPoint(new Vector3(0, 1, 10));
            Vector3 bottomRight = cam.ViewportToWorldPoint(new Vector3(1, 0, 10));
            int width = (int)((bottomRight.x - topLeft.x) / gap);
            for (int i = 0; i < transform.childCount; i++) {
                var child = transform.GetChild(i);
                child.position = new Vector3(1 + topLeft.x + gap * (i % width), -1 + topLeft.y - gap * (i / width), 0);
            }

        }

    }

}
