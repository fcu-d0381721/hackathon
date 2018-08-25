<?php


define("FIREBASE", "https://animap-3b23e.firebaseio.com/");

class firebase {

    var $curl, $node, $response;

    public function __construct() {
        $this->connect();
    }

    public function connect(){
        $this->curl = curl_init();
    }

    public function define_node($node){
        $this->node = "./accident/".$node.".json";
        print($this->node);
    }

    public function put($json_data) {
        curl_setopt( $this->curl, CURLOPT_URL, FIREBASE . $this->node );
        curl_setopt( $this->curl, CURLOPT_CUSTOMREQUEST, "PUT" );
        curl_setopt( $this->curl, CURLOPT_POSTFIELDS, $json_data );
    }
    public function get() {
        curl_setopt( $this->curl, CURLOPT_URL, FIREBASE . NODE );
    }
    public function delete() {
        curl_setopt( $this->curl, CURLOPT_URL, FIREBASE . $this->node );
        curl_setopt( $this->curl, CURLOPT_CUSTOMREQUEST, "DELETE" );

    }
    public function update($json_data) {
        curl_setopt( $this->curl, CURLOPT_URL, FIREBASE . $this->node);
        curl_setopt( $this->curl, CURLOPT_CUSTOMREQUEST, "PATCH" );
        curl_setopt( $this->curl, CURLOPT_POSTFIELDS, $json_data );

    }
    public function close(){
        curl_setopt( $this->curl, CURLOPT_RETURNTRANSFER, true );
        $this->response = curl_exec( $this->curl );
        curl_close( $this->curl );
        echo $this->response . "\n";
    }


}

?>