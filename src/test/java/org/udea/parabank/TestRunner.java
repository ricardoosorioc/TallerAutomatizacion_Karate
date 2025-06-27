package org.udea.parabank;

import com.intuit.karate.junit5.Karate;

class TestRunner {

    @Karate.Test
    Karate test01_ContactAppLogin() {
        return Karate.run("login")
                .relativeTo(getClass())
                .outputCucumberJson(true);
    }

    @Karate.Test
    Karate test02_ContactAppCreateContact() {
        return Karate.run("CreateContact")
                .relativeTo(getClass())
                .outputCucumberJson(true);
    }    

}
