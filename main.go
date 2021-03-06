package main

import (
	"fmt"
	"io/ioutil"
	"log"

	"github.com/google/logger"
	"github.com/jamf/groupsync/cmd"
	"github.com/logrusorgru/aurora"
)

func main() {
	defer logger.Init("groupsyncLogger", debug, false, ioutil.Discard).Close()

	// The debug format of logs includes the source file name. The release one
	// doesn't.
	if debug {
		logger.SetFlags(log.Lshortfile)
	} else {
		logger.SetFlags(log.LUTC)
	}

	if debug {
		fmt.Println(
			aurora.Red("You're using a dev build of groupsync."),
		)
	}

	cmd.Execute()
}
