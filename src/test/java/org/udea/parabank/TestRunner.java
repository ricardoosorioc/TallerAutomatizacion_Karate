package org.udea.parabank;

import com.intuit.karate.junit5.Karate;

class TestRunner {



    @Karate.Test
    Karate test02_ContactAppCreateContact() {
        return Karate.run("CreateContact")
                .relativeTo(getClass())
                .outputCucumberJson(true);
    }    

}
