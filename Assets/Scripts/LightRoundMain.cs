using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace ShaderAlgorithm {

    public class LightRoundMain : MonoBehaviour {

        [SerializeField] float roundSpeed = 45f;

        void Update() {
            transform.Rotate(new Vector3(roundSpeed * Time.deltaTime, 0, 0));
        }
    }

}
