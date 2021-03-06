package services

import "fmt"

// used for testing the service cache to verify the service gets initialized
// only once
var svcInitCount uint

type MockService struct {
}

func newMockService() MockService {
	svcInitCount += 1
	return MockService{}
}

func (t MockService) AddMembers(users []User) error {
	return nil
}

func (t MockService) RemoveMembers(users []User) error {
	return nil
}

func (t MockService) GroupMembers(group string) ([]User, error) {
	return nil, fmt.Errorf("unimplemented")
}

type MockIdentity struct {
	uid string
}

func newMockIdentity(uid uint32) MockIdentity {
	return MockIdentity{
		uid: fmt.Sprintf("%v", uid),
	}
}

// Implement Identity for MockIdentity.
func (i MockIdentity) uniqueID() string {
	return i.uid
}

func (i MockIdentity) String() string {
	return fmt.Sprintf("mockidentity{uid: %s}", i.uniqueID())
}
